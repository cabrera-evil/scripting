#!/bin/bash

# Colors for terminal output
BLUE='\e[0;34m'
GREEN='\e[0;32m'
RED='\e[0;31m'
NC='\e[0m' # No Color

# Packages to install
packages=(
    bat
    bluez
    build-essential
    curl
    git
    git-flow
    htop
    lsd
    ncdu
    neofetch
    ranger
    resolvconf
    rsync
    tmux
    trash-cli
    unzip
    unrar
    vim
    wireguard
    xclip
    zsh
    zip
    wget
)

# Update and install packages
echo -e "${BLUE}Updating package lists and installing packages...${NC}"
sudo apt update -y && sudo apt install -y "${packages[@]}"

echo -e "${GREEN}Packages installation complete!${NC}"
