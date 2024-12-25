# Dotfiles-iac

<p align="center">
  <a href="https://img.shields.io/badge/ansible000000.svg">
    <img src="https://img.shields.io/badge/-ansible-000000.svg?style=for-the-badge&logo=ansible&logoColor=white">
  </a>
  <a href="https://img.shields.io/badge/docker0db7ed.svg">
    <img src="https://img.shields.io/badge/-docker-0db7ed.svg?style=for-the-badge&logo=docker&logoColor=white">
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
Auxiliary repository for my Dotfiles project, responsible for creating test VMs on Proxmox for my labs, providing a fast and more efficient way to set up environments.

# Prerequisites
This code was developed with the assumption that SPICE is used as the Proxmox console. Therefore, if you're using SPICE, it is necessary to install the following package on the Host Machine:
- virt-viewer

# Usage

This code was written in Ansible, and works by using a external var and tags.
- external_vars: Specifies the supported operating systems. The valid values are
    - ubuntu
    - arch

- tags: Defines the operations you want to execute. The valid values are
    - create
    - post-install
    - start
    - stop
    - destroy

## Execution Flow
The commands define the following execution flow:

### 1. create
This command is used to create a VM on Proxmox. After that, access the VM through the Proxmox GUI and use the regular installation wizard. Once the installation is complete, stop the VM and proceed with the next command.

### 2. post-install
This command is used to:
- Remove the ISO from VM's CDROM
- change the boot order to boot from disk
- Convert VM into a template
- Clone the template into a new VM.

#### Manual Steps
At this point, manual steps must be executed inside the VM to ensure proper functionality. Run the following commands inside the VM:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server qemu-guest-agent spice-vdagent -y

sudo systemctl status ssh qemu-guest-agent spice-vdagent
sudo systemctl start ssh qemu-guest-agent spice-vdagent
sudo systemctl enable ssh qemu-guest-agent spice-vdagent
```

After completing these steps, it is recommended to create a snapshot in Proxmox.

### Other commands
The start, stop, and destroy commands are control commands used to manage the VM lifecycle.

## Ansible
To execute the playbook with Ansibl:
- Set the `os_type_list` external variable to either "ubuntu" or "arch".
- Adjust the tags to specify which commands to execute

```bash
ansible-playbook main.yaml -i hosts.yaml
    --extra-vars "os_type_list=['ubuntu','arch']"
    --tags "create"
```

## Docker
To run the playbook using Docker, update the docker-compose.yml file:
- Update the command field with the correct Ansible command.

Once configured, run:
```bash
docker compose up && sleep 1 && docker compose down
```

----

  ### License:

<p align="center">
  <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />
  </a>
</p>