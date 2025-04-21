#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://www.termius.com/download/linux/Termius.deb"

# Install Termius
echo -e "${BLUE}Downloading Termius...${NC}"
wget -O /tmp/termius.deb "$URL"

echo -e "${BLUE}Installing Termius...${NC}"
sudo apt install -y /tmp/termius.deb

echo -e "${GREEN}Termius installation complete!${NC}"
