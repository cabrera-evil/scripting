#!/bin/zsh

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

# Install snapd
echo -e "${BLUE}Installing snapd...${NC}"
sudo apt install snapd -y
handle_error $? "apt install snapd" "Failed to install snapd"

# Install microk8s
echo -e "${BLUE}Installing microk8s...${NC}"
sudo snap install microk8s --classic
handle_error $? "snap install microk8s" "Failed to install microk8s"

# Add user to microk8s group
echo -e "${BLUE}Adding user to microk8s group...${NC}"
sudo usermod -aG microk8s $USER
handle_error $? "usermod" "Failed to add user to microk8s group"

# Reload user groups
echo -e "${BLUE}Reloading user groups...${NC}"
newgrp microk8s
handle_error $? "newgrp" "Failed to reload user groups"

# Wait for microk8s to start
echo -e "${BLUE}Waiting for microk8s to start...${NC}"
microk8s status --wait-ready
handle_error $? "microk8s status" "Failed to start microk8s"

# Create microk8s cache dir
echo -e "${BLUE}Creating microk8s cache dir...${NC}"
mkdir -p $HOME/.kube
chmod 0700 $HOME/.kube
handle_error $? "mkdir" "Failed to create microk8s cache dir"

# Enable microk8s services
echo -e "${BLUE}Enabling microk8s services...${NC}"
microk8s enable dns dashboard helm hostpath-storage ingress
handle_error $? "microk8s enable" "Failed to enable microk8s services"

echo -e "${GREEN}microk8s installed successfully!${NC}"
