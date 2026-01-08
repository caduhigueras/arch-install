#!/bin/bash

until getent hosts deb.debian.org >/dev/null 2>&1; do
  sleep 2
done
