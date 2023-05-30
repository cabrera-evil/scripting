#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#Install Kvm For Virtualization
echo -e "${BLUE}Installing KVM${NC}"
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
kvm-ok

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

#Docker Install
echo -e "${BLUE}Installing Docker${NC}"
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#Setup The Repository
echo -e "${BLUE}Setting up Docker repository${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
#Download A Test Version (Then You Can Update)
echo -e "${BLUE}Downloading latest version of Docker Desktop${NC}"
wget -O /tmp/docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.18.0-amd64.deb"

#Install The Downloaded Package
echo -e "${BLUE}Installing Docker Desktop${NC}"
sudo apt-get update
sudo dpkg -i /tmp/docker-desktop.deb

#Cheking Version
echo -e "${BLUE}Checking Docker version${NC}"
docker compose version
docker --version
docker version

#Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

#Open Docker-Desktop
echo -e "${BLUE}Opening Docker Desktop${NC}"
systemctl --user start docker-desktop