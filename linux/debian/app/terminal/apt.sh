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

# Install htop
echo -e "${BLUE}Installing htop...${NC}"
sudo apt install htop -y
handle_error $? "apt install htop" "Failed to install htop"

# Install neofetch
echo -e "${BLUE}Installing neofetch...${NC}"
sudo apt install neofetch -y
handle_error $? "apt install neofetch" "Failed to install neofetch"

# Install git and git-flow
echo -e "${BLUE}Installing git and git-flow...${NC}"
sudo apt install git git-flow -y
handle_error $? "apt install git git-flow" "Failed to install git and git-flow"

# Install vim
echo -e "${BLUE}Installing vim...${NC}"
sudo apt install vim -y
handle_error $? "apt install vim" "Failed to install vim"

# Install build-essential
echo -e "${BLUE}Installing build-essential...${NC}"
sudo apt install build-essential -y
handle_error $? "apt install build-essential" "Failed to install build-essential"

# Install xclip
echo -e "${BLUE}Installing xclip...${NC}"
sudo apt install xclip -y
handle_error $? "apt install xclip" "Failed to install xclip"

# Install unzip
echo -e "${BLUE}Installing unzip...${NC}"
sudo apt install unzip -y
handle_error $? "apt install unzip" "Failed to install unzip"

# Install unrar
echo -e "${BLUE}Installing unrar...${NC}"
sudo apt install unrar -y
handle_error $? "apt install unrar" "Failed to install unrar"

# Install numix-icon-theme-circle
echo -e "${BLUE}Installing numix-icon-theme-circle...${NC}"
sudo apt install numix-icon-theme-circle -y
handle_error $? "apt install numix-icon-theme-circle" "Failed to install numix-icon-theme-circle"

# Install tmux
echo -e "${BLUE}Installing tmux...${NC}"
sudo apt install tmux -y
handle_error $? "apt install tmux" "Failed to install tmux"

# Install ncdu
echo -e "${BLUE}Installing ncdu...${NC}"
sudo apt install ncdu -y
handle_error $? "apt install ncdu" "Failed to install ncdu"

# Install trash-cli
echo -e "${BLUE}Installing trash-cli...${NC}"
sudo apt install trash-cli -y
handle_error $? "apt install trash-cli" "Failed to install trash-cli"

# Install ranger
echo -e "${BLUE}Installing ranger...${NC}"
sudo apt install ranger -y
handle_error $? "apt install ranger" "Failed to install ranger"

