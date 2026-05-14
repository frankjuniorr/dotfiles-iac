#!/bin/bash

HTML=$(curl -s https://omarchy.org)

ISO_URL=$(echo "$HTML" | grep -oP 'https://iso\.omarchy\.org/omarchy-[\d.]+-?\d*\.iso' | head -n1)

echo "$ISO_URL"
