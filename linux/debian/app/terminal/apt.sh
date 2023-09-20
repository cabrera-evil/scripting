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
sudo apt install htop -y
handle_error $? "apt install htop" "Failed to install htop"
sudo apt install neofetch -y
handle_error $? "apt install neofetch" "Failed to install neofetch"

# Install Git as version controller
echo -e "${BLUE}Installing Vim...${NC}"
sudo apt install vim -y
handle_error $? "apt install vim" "Failed to install vim"

# Install basic development tools
echo -e "${BLUE}Installing Basic Development Tools...${NC}"
sudo apt install build-essential -y
handle_error $? "apt install build-essential" "Failed to install build-essential"

# Install xclip as clipboard manager
echo -e "${BLUE}Installing xclip as clipboard manager...${NC}"
sudo apt install xclip -y
handle_error $? "apt install xclip" "Failed to install xclip"
