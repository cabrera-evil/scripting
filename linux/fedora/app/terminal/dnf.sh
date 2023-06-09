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

# Install basic applications
echo -e "${BLUE}Installing Basic Applications...${NC}"
sudo dnf install htop -y
handle_error $? "Install htop" "Failed to install htop"
sudo dnf install neofetch -y
handle_error $? "Install neofetch" "Failed to install neofetch"

# Install Git as version controller
echo -e "${BLUE}Installing Git as version controller${NC}"
sudo dnf install git -y
handle_error $? "Install Git" "Failed to install Git"
sudo dnf install gnome-keyring -y
handle_error $? "Install gnome-keyring" "Failed to install gnome-keyring"

# Install basic development tools
echo -e "${BLUE}Installing Basic Development Tools...${NC}"
sudo dnf install @development-tools -y
handle_error $? "Install development tools" "Failed to install development tools"

# Install ark as archive manager
echo -e "${BLUE}Installing ark as archive manager...${NC}"
sudo dnf install ark -y
handle_error $? "Install ark" "Failed to install ark"