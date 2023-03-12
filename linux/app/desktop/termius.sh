#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Termius
clear
echo -e "${BLUE}Downloading Termius...${NC}"
if ! wget -O /tmp/termius.deb "https://www.termius.com/download/linux/Termius.deb?_gl=1*i4xdht*_ga*MzQ0ODY0MDczLjE2MTY2MjI5ODE.*_ga_ZPQLW2Q816*MTY1NjM4MDU2Mi44My4xLjE2NTYzODIyNzguMA.."; then
    echo -e "${RED}Failed to download Termius.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing Termius...${NC}"
if ! sudo dpkg -i /tmp/termius.deb; then
    echo -e "${RED}Failed to install Termius.${NC}"
    exit 1
fi

echo -e "${GREEN}Termius installation complete!${NC}"
