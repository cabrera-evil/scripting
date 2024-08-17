#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Downloading VirtualBox
echo -e "${BLUE}Downloading VirtualBox${NC}"
wget -O /tmp/virtualbox.deb "https://download.virtualbox.org/virtualbox/7.0.10/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb"

# Installing VirtualBox
echo -e "${BLUE}Installing VirtualBox${NC}"
sudo apt install -y /tmp/virtualbox.deb

echo -e "${GREEN}VirtualBox installation complete!${NC}"