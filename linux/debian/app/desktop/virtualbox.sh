#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Debian~bookworm_amd64.deb"

# Downloading VirtualBox
echo -e "${BLUE}Downloading VirtualBox${NC}"
wget -O /tmp/virtualbox.deb "$URL"

# Installing VirtualBox
echo -e "${BLUE}Installing VirtualBox${NC}"
sudo apt install -y /tmp/virtualbox.deb

echo -e "${GREEN}VirtualBox installation complete!${NC}"