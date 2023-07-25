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

# Install vim as text editor
echo -e "${BLUE}Installing vim as text editor...${NC}"
sudo dnf install vim -y
handle_error $? "Install vim" "Failed to install vim"

# Install unzip and unrar as rar file manager
echo -e "${BLUE}Installing unzip and unrar as rar file manager...${NC}"
sudo dnf install unzip -y
handle_error $? "Install unzip" "Failed to install unzip"
sudo dnf install unrar -y
handle_error $? "Install unrar" "Failed to install unrar"

# Install xclip as clipboard manager
echo -e "${BLUE}Installing xclip as clipboard manager...${NC}"
sudo dnf install xclip -y
handle_error $? "Install xclip" "Failed to install xclip"