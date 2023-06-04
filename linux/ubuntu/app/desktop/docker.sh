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

#Docker Install
echo -e "${BLUE}Installing Docker${NC}"
sudo apt install -y ca-certificates curl gnupg lsb-release
handle_error $? "Docker Installation" "Failed to install Docker"

#Setup The Repository
echo -e "${BLUE}Setting up Docker repository${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Download A Test Version (Then You Can Update)
echo -e "${BLUE}Downloading latest version of Docker Desktop${NC}"
wget -O /tmp/docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.18.0-amd64.deb"
handle_error $? "Docker Desktop Download" "Failed to download Docker Desktop"

#Install The Downloaded Package
echo -e "${BLUE}Installing Docker Desktop${NC}"
sudo apt-get update
sudo dpkg -i /tmp/docker-desktop.deb
handle_error $? "Docker Desktop Installation" "Failed to install Docker Desktop"

#Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

echo -e "${GREEN}Docker installation and configuration complete!${NC}"

# Install docker-compose
echo -e "${BLUE}Installing docker-compose...${NC}"
sudo apt-get install docker-compose -y
handle_error $? "apt-get install docker-compose" "Failed to install docker-compose"

# Enable keyring for docker hub
# Install the necessary package to use the pass credential store
sudo apt-get install -y pass gnupg2
handle_error $? "Installation" "Failed to install required packages."

# Generate a new GPG key
gpg --generate-key
handle_error $? "GPG Key Generation" "Failed to generate GPG key."

# Get the generated public GPG key ID
gpg_key=$(gpg --list-keys --keyid-format LONG | grep pub | awk '{print $2}' | cut -d'/' -f2)
handle_error $? "GPG Key Retrieval" "Failed to retrieve GPG key."

# Initialize pass using the generated public GPG key
pass init "$gpg_key"
handle_error $? "Pass Initialization" "Failed to initialize pass."

# Restart the Docker service to apply the changes
sudo systemctl restart docker
handle_error $? "Docker Service Restart" "Failed to restart Docker service."

echo -e "${GREEN}Pass credential store configured successfully.${NC}"