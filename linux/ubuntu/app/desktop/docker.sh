#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

#Install Kvm For Virtualization
echo -e "${BLUE}Installing KVM${NC}"
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
handle_error $? "KVM Installation" "Failed to install KVM"

#Update System Package
echo -e "${BLUE}Updating system packages${NC}"
sudo apt update && sudo apt upgrade -y
[ -f /var/run/reboot-required ] && sudo reboot -f

#Configure Kvm Support
echo -e "${BLUE}Setting up KVM${NC}"
sudo modprobe kvm
lsmod | grep kvm
ls -al /dev/kvm

#Add user to kvm
echo -e "${BLUE}Adding user to KVM${NC}"
sudo usermod -aG kvm $USER

#Delete Old Installations
echo -e "${BLUE}Cleaning old installations${NC}"
sudo apt remove docker-desktop
sudo dpkg -r docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop

#Apt Packages Install
echo -e "${BLUE}Installing apt package index for HTTPS${NC}"
sudo apt install ca-certificates curl gnupg -y
handle_error $? "apt package" "Failed to install apt packages"

#Setup GPG Key
echo -e "${BLUE}Setting up GPG key${NC}"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
handle_error $? "GPG Key Setup" "Failed to setup GPG key"

#Setup The Repository
echo -e "${BLUE}Setting up Docker repository${NC}"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Installing Docker Engine
echo -e "${BLUE}Installing Docker Engine${NC}"
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
handle_error $? "Docker Engine Installation" "Failed to install Docker Engine"

#Download Docker Desktop
echo -e "${BLUE}Downloading latest version of Docker Desktop${NC}"
wget -O /tmp/docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.21.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*1n2j3yy*_ga*MTk4NjM4NzY0LjE2ODk3OTM4MTQ.*_ga_XJWPQMJYHQ*MTY5MDA3MDA3MC40LjEuMTY5MDA3MDUxMS41Ni4wLjA."
handle_error $? "Docker Desktop Download" "Failed to download Docker Desktop"

#Install The Downloaded Package
echo -e "${BLUE}Installing Docker Desktop${NC}"
sudo apt update -y
sudo apt install /tmp/docker-desktop.deb
handle_error $? "Docker Desktop Installation" "Failed to install Docker Desktop"

#Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

echo -e "${GREEN}Docker installation and configuration complete!${NC}"