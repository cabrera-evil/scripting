#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download and install VMware Player
clear
echo -e "${BLUE}Downloading VMware Player...${NC}"
if ! wget -O /tmp/vmware.bundle "https://download3.vmware.com/software/WKST-PLAYER-1702/VMware-Player-Full-17.0.2-21581411.x86_64.bundle"; then
    echo -e "${RED}Failed to download VMware Player.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing VMware Player...${NC}"
if ! sudo sh /tmp/vmware.bundle; then
    echo -e "${RED}Failed to install VMware Player.${NC}"
    exit 1
fi

echo -e "${GREEN}VMware Player installation complete!${NC}"
