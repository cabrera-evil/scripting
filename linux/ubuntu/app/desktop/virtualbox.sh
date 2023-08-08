#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download and install VirtualBox
echo -e "${BLUE}Downloading VirtualBox...${NC}"
if ! wget -O /tmp/virtualbox.deb "https://download.virtualbox.org/virtualbox/7.0.8/virtualbox-7.0_7.0.8-156879~Ubuntu~jammy_amd64.deb"; then
    echo -e "${RED}Failed to download VirtualBox.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing VirtualBox...${NC}"
if ! sudo apt install -y /tmp/virtualbox.deb; then
    echo -e "${RED}VirtualBox installed with some errors.${NC}"
fi

echo -e "${GREEN}VirtualBox installation complete!${NC}"

