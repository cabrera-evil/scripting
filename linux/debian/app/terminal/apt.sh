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

# Install packages
echo -e "${BLUE}Installing packages...${NC}"
sudo apt update -y
sudo apt install -y htop neofetch git git-flow vim build-essential xclip unzip unrar tmux ncdu trash-cli ranger zsh bluez rsync
handle_error $? "apt install packages" "Failed to install packages"
