#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install packages
echo -e "${BLUE}Installing packages...${NC}"
sudo apt update -y
sudo apt install -y htop neofetch git git-flow vim build-essential xclip unzip unrar tmux ncdu trash-cli ranger zsh bluez rsync

echo -e "${GREEN}Packages installation complete!${NC}"