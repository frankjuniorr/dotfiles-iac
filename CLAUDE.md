# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Auxiliary IaC project that creates and manages Proxmox test VMs (Ubuntu, Arch Linux, and Omarchy) for the `dotfiles` project. Automates the full VM lifecycle: ISO download → VM creation → post-install template/clone → start/stop/destroy.

## Commands

```bash
# Primary interface via just (granular shortcuts)
just create omarchy        # create VM (ISO download + qm setup)
just post-install omarchy  # convert to template + clone
just start omarchy
just stop omarchy
just destroy omarchy

# Base command (used internally by shortcuts)
just playbook "<tag>" "<os>"   # e.g. just playbook "create" "ubuntu"

# Direct ansible (when debugging)
ansible-playbook main.yaml -i hosts.yaml \
  --extra-vars "os_type_list=['omarchy']" \
  --tags "create"

# Setup
just install-hooks
ansible-galaxy collection install -r requirements.yaml
```

Valid tags: `create`, `post-install`, `start`, `stop`, `destroy`
Valid OS values: `ubuntu`, `arch`, `omarchy`

## Architecture

`main.yaml` is the single playbook. It parses `os_type_list` (YAML string passed as extra-var) into a list and loops over it, delegating to one of five roles per tag.

**Variable loading**: Each role's `main.yaml` starts with `include_vars: file: "group_vars/{{ os }}.yaml"` — there is no inventory group; vars are loaded dynamically per-OS at role execution time. OS-specific config lives in `group_vars/ubuntu.yaml`, `group_vars/arch.yaml`, and `group_vars/omarchy.yaml`.

**VM IDs**:
- Ubuntu: template `100` → VM `101`
- Arch: template `200` → VM `201`
- Omarchy: template `300` → VM `301`

All use `local-lvm` storage. Ubuntu/Arch: 4GB RAM, 2 cores, 25G disk. Omarchy: 8GB RAM, 4 cores, 40G disk (desktop environment).

**create role** — downloads ISO (OS-specific subtasks: `arch-download.yaml`, `ubuntu-download.yaml`, `omarchy-download.yaml`), then `proxmox-create-vm.yaml` runs `qm` shell commands to build the VM.

- `arch-download.yaml` — scrapes the Arch mirror directory listing for the latest ISO filename
- `ubuntu-download.yaml` — runs `files/ubuntu-download.sh` on the remote host to find the latest LTS ISO URL
- `omarchy-download.yaml` — runs `files/omarchy-download.sh` on the remote host to find the ISO URL from omarchy.org

**post-install role** — stops the VM, removes CDROM, sets boot disk to `scsi0`, converts to template, clones the template to a new VM.

**start/stop/destroy** — simple `qm start/stop/destroy` wrappers.

## Callback Plugin

The `callback_plugins/beautiful_output.py` plugin produces clean, readable Ansible output. It requires `watchdog` (`pip install watchdog`).

Toggle with `just plugin on|off`. The pre-commit hook always ensures it's on before committing.

## Proxmox Target

`hosts.yaml` points to `192.168.0.115` as `root`. The `iso_directory` host var is `/var/lib/vz/template/iso`.
