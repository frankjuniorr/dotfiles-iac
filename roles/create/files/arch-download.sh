#!/bin/bash

HTML=$(curl -s "https://archlinux.c3sl.ufpr.br/iso/latest/")

ISO_FILE=$(echo "$HTML" | grep -oP 'archlinux-\d{4}\.\d{2}\.\d{2}-x86_64\.iso' | head -n1)

echo "https://archlinux.c3sl.ufpr.br/iso/latest/${ISO_FILE}"
