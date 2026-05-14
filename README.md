# Dotfiles-iac

<p align="center">
  <a href="https://img.shields.io/badge/ansible000000.svg">
    <img src="https://img.shields.io/badge/-ansible-000000.svg?style=for-the-badge&logo=ansible&logoColor=white">
  </a>
  <a href="https://img.shields.io/badge/dockere57000.svg">
    <img src="https://img.shields.io/badge/-Proxmox-e57000.svg?style=for-the-badge&logo=proxmox&logoColor=white">
  </a>
  <br>
  <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img src="https://img.shields.io/badge/-CC_BY--SA_4.0-000000.svg?style=for-the-badge&logo=creative-commons&logoColor=white"/>
  </a>
</p>

# Description
Auxiliary repository for the [Dotfiles](https://github.com/frankjuniorr/dotfiles) project, responsible for creating test VMs on Proxmox. Supports Ubuntu, Arch Linux, and Omarchy.

# Prerequisites
Install Remmina on the host machine to access the Proxmox console:
- `remmina`

# Setup
```bash
just init
```

# Usage

This code is written in Ansible and works with external vars and tags.

- **OS values:** `ubuntu`, `arch`, `omarchy`
- **Tags (operations):** `create`, `post-install`, `start`, `stop`, `destroy`

## Execution Flow

### 1. create
Creates a VM on Proxmox with the specified OS ISO. After the VM is created, access it through the Proxmox GUI and run the installation wizard. Once the installation is complete, stop the VM.

### 2. post-install
- Removes the ISO from the VM's CDROM
- Changes boot order to boot from disk
- Converts VM into a template
- Clones the template into a new VM

#### Manual Steps (Ubuntu)
Run inside the VM (via Remmina console) after installation — see `roles/post-install/files/ubuntu-setup.sh`.

After completing these steps, it is recommended to create a snapshot in Proxmox.

### Other commands
`start`, `stop`, and `destroy` manage the VM lifecycle.

## Just
```bash
just create omarchy
just create ubuntu
just create arch

just post-install omarchy
just stop omarchy
just destroy omarchy
```

## Ansible
```bash
ansible-playbook main.yaml -i hosts.yaml \
    --extra-vars "os_type_list=['omarchy']" \
    --tags "create"
```

## VM IDs

| OS      | Template ID | VM ID |
|---------|-------------|-------|
| Ubuntu  | 100         | 101   |
| Arch    | 200         | 201   |
| Omarchy | 300         | 301   |

---

  ### License:

<p align="center">
  <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />
  </a>
</p>
