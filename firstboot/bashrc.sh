#!/usr/bin/env bash

cat <<'EOF' >> ~/.bashrc

## Custom aliases
alias gomdocker='cd $HOME/app/docker-magento-setup'
alias cda='cd $HOME/.local/share/arch-dotfiles/'
alias cdapp='cd $HOME/app/'
alias cdb='cd $HOME/files/backups/'
alias cdd='cd $HOME/app/hubspot/private_apps/prod/hs-ui-extensions/deal_matrix/'
alias cddoc='cd $HOME/Documents/'
alias cddow='cd $HOME/Downloads/'
alias cdf='cd $HOME/files/'
alias cdi='cd $HOME/app/dev/arch-install/'
alias cdm='cd $HOME/app/magento/'
alias cdm2='docker exec -it php-fpm bash'
alias cdo='cd $HOME/Documents/Obsidian\ Vault/'
alias cds='cd $HOME/app/sites'
alias cdsc='cd $HOME/files/scratches/'
alias showtime='date +"%T"'


## Starting main Magento Docker
m2start() {
    cd $HOME/app/docker-magento-setup/
    docker compose up -d
}

## Tar functions
tarextract() {
    tar -xzvf $1
}

tarcompress() {
    tar -czvf $1 $2
}

## Split CSVs
splitCsv() {
    HEADER=$(head -1 $1)
    if [ -n "$2" ]; then
        CHUNK=$2
    else 
        CHUNK=1000
    fi
    tail -n +2 $1 | split -l $CHUNK - $1_split_
    for i in $1_split_*; do
        sed -i -e "1i$HEADER" "$i"
    done
}

showmycmds() {
    echo "########## ALIASES ##########"
    echo "gomdocker => cd $HOME/app/docker-magento-setup/"
    echo "cda => cd $HOME/.local/share/arch-dotfiles/"
    echo "cdapp => cd $HOME/app/"
    echo "cdb => cd $HOME/files/backups/"
    echo "cdd => cd $HOME/app/hubspot/private_apps/prod/hs-ui-extensions/deal_matrix/"
    echo "cddoc => cd $HOME/Documents/"
    echo "cddow => cd $HOME/Downloads/"
    echo "cdf => cd $HOME/files/"
    echo "cdi => cd $HOME/app/dev/arch-install/"
    echo "cdm => cd $HOME/app/magento/"
    echo "cdm2 => docker exec -it php-fpm bash"
    echo "cdn => cd $HOME/.config/nvim"
    echo "cdo => cd $HOME/.local/share/obsidian"
    echo "cds =>cd $HOME/app/sites"
    echo "cdsc => cd $HOME/files/scratches/"
    echo "showtime => show current time in the terminal"
    echo ""
    echo ""
    echo "########## FUNCTIONS ##########"
    echo "tarextract => Extract tar (Usage: tarextract filename)"
    echo "tarcompress => Compress file into tar (Usage: tarcompress filetarname filename)"
    echo "splitCsv => Split CSV in multi files per line count (Usage: splitCsv <Filename> [chunkSize])"
    echo "m2start => Starts the main magento project"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export EDITOR="nvim"

export PATH="$HOME/.npm-global/bin:$PATH"

[[ -r /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

EOF

