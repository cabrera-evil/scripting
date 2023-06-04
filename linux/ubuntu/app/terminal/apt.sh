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
sudo apt-get install htop -y
handle_error $? "apt-get install htop" "Failed to install htop"
sudo apt-get install neofetch -y
handle_error $? "apt-get install neofetch" "Failed to install neofetch"

# Install Git as version controller
echo -e "${BLUE}Installing Git as version controller${NC}"
sudo apt-get install git -y
handle_error $? "apt-get install git" "Failed to install git"
sudo apt-get install gnome-keyring -y
handle_error $? "apt-get install gnome-keyring" "Failed to install gnome-keyring"

# Install basic development tools
echo -e "${BLUE}Installing Basic Development Tools...${NC}"
sudo apt-get install build-essential -y
handle_error $? "apt-get install build-essential" "Failed to install build-essential"

echo -e "${GREEN}Installation of basic applications and development tools complete!${NC}"
