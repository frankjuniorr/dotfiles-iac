#!/bin/bash

# Busca o HTML da página de releases
HTML=$(curl -s https://releases.ubuntu.com/)

LTS_VERSION=$(echo "$HTML" | grep "LTS" | grep -oP '(?<=href=")[0-9]{2}\.[0-9]{2}\.[0-9]{1,2}/' | sort -Vr | uniq | head -n1 | tr -d '/')
CODENAME=$(echo "$HTML" | grep "$LTS_VERSION" | grep -oP '<a href="\K[a-z]+(?=/")' | head -n1)

URL="https://releases.ubuntu.com/${CODENAME}/ubuntu-${LTS_VERSION}-desktop-amd64.iso"

echo "$URL"