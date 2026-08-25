#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Arch Linux + QEMU/KVM + libvirt sandbox setup
#
# Creates:
#   sandbox network
#   192.168.250.0/24
#   gateway: 192.168.250.1
#   DHCP:    192.168.250.100-200
#
# Allows:
#   sandbox -> Internet
#
# Blocks:
#   sandbox -> 192.168.1.0/24
#
# Does NOT yet block:
#   sandbox -> host's own LAN IP
#
# Run as your normal user:
#   chmod +x setup-sandbox.sh
#   ./setup-sandbox.sh
# ============================================================

if [[ $EUID -eq 0 ]]; then
    echo "Run this script as your normal user, not root."
    exit 1
fi

USERNAME="$(id -un)"

echo
echo "=============================================="
echo " Installing virtualization packages"
echo "=============================================="
echo

sudo pacman -S --needed --noconfirm  \
    qemu-desktop \
    libvirt \
    virt-manager \
    virt-viewer \
    dnsmasq \
    edk2-ovmf \
    iptables

echo
echo "=============================================="
echo " Enabling libvirt"
echo "=============================================="
echo

# Modern libvirt uses modular daemons/socket activation.
# Enable both the QEMU and network management sockets.
sudo systemctl enable --now virtqemud.socket
sudo systemctl enable --now virtnetworkd.socket

# Some installations/tools still expect the traditional socket.
# If present, enable it too.
if systemctl list-unit-files | grep -q '^libvirtd.socket'; then
    sudo systemctl enable --now libvirtd.socket || true
fi

echo
echo "=============================================="
echo " Adding user to libvirt group"
echo "=============================================="
echo

sudo usermod -aG libvirt "$USERNAME"

echo
echo "IMPORTANT:"
echo "Your current login session does not automatically gain"
echo "the new libvirt group membership."
echo
echo "You can either log out/in after this script, or run:"
echo
echo "    newgrp libvirt"
echo

echo
echo "=============================================="
echo " Detecting Internet interface"
echo "=============================================="
echo

WAN_IF="$(ip route get 1.1.1.1 | awk '
    {
        for (i = 1; i <= NF; i++)
            if ($i == "dev") {
                print $(i+1)
                exit
            }
    }
')"

if [[ -z "${WAN_IF}" ]]; then
    echo "ERROR: Could not determine Internet interface."
    exit 1
fi

echo "Internet interface: ${WAN_IF}"

echo
echo "=============================================="
echo " Enabling IPv4 forwarding"
echo "=============================================="
echo

sudo tee /etc/sysctl.d/99-libvirt-sandbox.conf >/dev/null <<'EOF'
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system >/dev/null

echo
echo "=============================================="
echo " Configuring libvirt firewall backend"
echo "=============================================="
echo

# Current libvirt versions support the nftables backend.
# This keeps libvirt's own NAT/firewall rules separate from
# the iptables compatibility rules used by other software.
sudo mkdir -p /etc/libvirt

if [[ -f /etc/libvirt/network.conf ]]; then
    if grep -q '^[[:space:]]*firewall_backend' /etc/libvirt/network.conf; then
        sudo sed -i \
            's/^[[:space:]]*firewall_backend.*/firewall_backend = "nftables"/' \
            /etc/libvirt/network.conf
    else
        echo 'firewall_backend = "nftables"' |
            sudo tee -a /etc/libvirt/network.conf >/dev/null
    fi
else
    echo 'firewall_backend = "nftables"' |
        sudo tee /etc/libvirt/network.conf >/dev/null
fi

echo
echo "=============================================="
echo " Creating sandbox libvirt network"
echo "=============================================="
echo

NETWORK_XML="$(mktemp)"

cat > "$NETWORK_XML" <<'EOF'
<network>
  <name>sandbox</name>

  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>

  <bridge name='virbr1' stp='on' delay='0'/>

  <ip address='192.168.250.1'
      netmask='255.255.255.0'>

    <dhcp>
      <range start='192.168.250.100'
             end='192.168.250.200'/>
    </dhcp>

  </ip>
</network>
EOF

if sudo virsh -c qemu:///system net-info sandbox >/dev/null 2>&1; then
    echo "sandbox network already exists."

    sudo virsh -c qemu:///system net-destroy sandbox 2>/dev/null || true
    sudo virsh -c qemu:///system net-undefine sandbox 2>/dev/null || true
fi

sudo virsh -c qemu:///system net-define "$NETWORK_XML"
sudo virsh -c qemu:///system net-autostart sandbox
sudo virsh -c qemu:///system net-start sandbox

rm -f "$NETWORK_XML"

echo
echo "=============================================="
echo " Configuring sandbox firewall"
echo "=============================================="
echo

# ------------------------------------------------------------
# Create our own forwarding chain.
#
# We deliberately do NOT modify FORWARD policy.
# This is important because Docker or another firewall
# manager may legitimately use FORWARD=DROP.
# ------------------------------------------------------------

if ! sudo iptables -nL SANDBOX-FORWARD >/dev/null 2>&1; then
    sudo iptables -N SANDBOX-FORWARD
fi

# Remove our jump if it already exists, then insert exactly once.
while sudo iptables -C FORWARD -j SANDBOX-FORWARD 2>/dev/null; do
    sudo iptables -D FORWARD -j SANDBOX-FORWARD
done

sudo iptables -I FORWARD 1 -j SANDBOX-FORWARD

# Clear our own chain so this script is safely re-runnable.
sudo iptables -F SANDBOX-FORWARD

# ------------------------------------------------------------
# Existing connections coming back from the Internet
# ------------------------------------------------------------

sudo iptables -A SANDBOX-FORWARD \
    -i "$WAN_IF" \
    -o virbr1 \
    -d 192.168.250.0/24 \
    -m conntrack \
    --ctstate ESTABLISHED,RELATED \
    -j ACCEPT

# ------------------------------------------------------------
# Explicitly block the physical LAN.
#
# This assumes the LAN we are protecting is 192.168.1.0/24,
# matching the machine on which we built the original sandbox.
# ------------------------------------------------------------

sudo iptables -A SANDBOX-FORWARD \
    -i virbr1 \
    -o "$WAN_IF" \
    -s 192.168.250.0/24 \
    -d 192.168.1.0/24 \
    -j DROP

# ------------------------------------------------------------
# Allow sandbox -> Internet.
#
# NAT is handled by libvirt.
# ------------------------------------------------------------

sudo iptables -A SANDBOX-FORWARD \
    -i virbr1 \
    -o "$WAN_IF" \
    -s 192.168.250.0/24 \
    -j ACCEPT

echo
echo "=============================================="
echo " Saving firewall configuration"
echo "=============================================="
echo

sudo mkdir -p /etc/iptables

sudo iptables-save |
    sudo tee /etc/iptables/iptables.rules >/dev/null

sudo systemctl enable iptables.service

echo
echo "=============================================="
echo " Verification"
echo "=============================================="
echo

echo
echo "Libvirt networks:"
sudo virsh -c qemu:///system net-list --all

echo
echo "Sandbox network:"
sudo virsh -c qemu:///system net-dumpxml sandbox

echo
echo "IPv4 forwarding:"
sysctl net.ipv4.ip_forward

echo
echo "Internet interface:"
echo "$WAN_IF"

echo
echo "Sandbox firewall:"
sudo iptables -L SANDBOX-FORWARD -v -n --line-numbers

echo
echo "=============================================="
echo " Setup complete"
echo "=============================================="
echo

echo "The sandbox network is:"
echo
echo "    192.168.250.0/24"
echo "    gateway: 192.168.250.1"
echo "    DHCP:    192.168.250.100-200"
echo
echo "VMs attached to 'sandbox' should have Internet access"
echo "through NAT, while 192.168.1.0/24 is blocked."
echo
echo "IMPORTANT:"
echo "Log out and back in (or run 'newgrp libvirt') before"
echo "using virt-manager as your normal user."
echo
echo "When creating the VM, select the 'sandbox' network."
echo
