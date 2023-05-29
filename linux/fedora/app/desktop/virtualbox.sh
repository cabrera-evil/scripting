#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

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

# Step 1: Install Dependencies
echo -e "${BLUE}Step 1: Installing Dependencies...${NC}"
sudo dnf -y install @development-tools
handle_error $? "Failed to install development tools" 

sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras
handle_error $? "Failed to install kernel headers and other dependencies"

# Step 2: Add VirtualBox RPM repository
echo -e "${BLUE}Step 2: Adding VirtualBox RPM repository...${NC}"
VERSION=38
cat <<EOF | sudo tee /etc/yum.repos.d/virtualbox.repo 
[virtualbox]
name=Fedora VirtualBox Repo
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/$VERSION/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox_2016.asc
EOF
handle_error $? "Failed to add VirtualBox RPM repository"

# Step 3: Import VirtualBox GPG Key
echo -e "${BLUE}Step 3: Importing VirtualBox GPG Key...${NC}"
sudo dnf -y search virtualbox
handle_error $? "Failed to import VirtualBox GPG key"

# Step 4: Install VirtualBox 7.0 on Fedora
echo -e "${BLUE}Step 4: Installing VirtualBox 7.0...${NC}"
sudo dnf -y install VirtualBox-7.0
handle_error $? "Failed to install VirtualBox"

# Step 5: Add your user to the vboxusers group
echo -e "${BLUE}Step 5: Adding user to the vboxusers group...${NC}"
sudo usermod -a -G vboxusers $USER
newgrp vboxusers
id $USER

# Display success message
echo -e "${GREEN}VirtualBox installation completed successfully.${NC}"
