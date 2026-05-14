#!/usr/bin/env bash
# Run this inside the Ubuntu VM (via console) after the installation wizard.
# Once SSH is active, Ansible can manage the VM remotely.
set -euo pipefail

sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server qemu-guest-agent spice-vdagent

sudo systemctl enable --now ssh qemu-guest-agent spice-vdagent
