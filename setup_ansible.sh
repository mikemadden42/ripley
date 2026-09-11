#!/bin/sh
# Install Ansible and the bits the playbooks in this repo need.
# Set USE_PPA=1 on Ubuntu to pull Ansible from ppa:ansible/ansible
# instead of the distro archive.

set -eu

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

. /etc/os-release

case "$ID" in
    debian | ubuntu | kali | pop | linuxmint | raspbian)
        $SUDO apt-get update
        if [ "$ID" = "ubuntu" ] && [ "${USE_PPA:-0}" = "1" ]; then
            $SUDO apt-get install -y software-properties-common
            $SUDO apt-add-repository --yes --update ppa:ansible/ansible
        fi
        $SUDO apt-get install -y ansible aptitude python3-apt
        ;;
    fedora)
        $SUDO dnf install -y ansible
        ;;
    almalinux | rocky | centos | rhel)
        $SUDO dnf install -y epel-release
        $SUDO dnf install -y ansible
        ;;
    arch | manjaro | endeavouros)
        $SUDO pacman -Sy --needed --noconfirm ansible
        ;;
    *)
        echo "setup_ansible.sh: unsupported distro: $ID" >&2
        exit 1
        ;;
esac
