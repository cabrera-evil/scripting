#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

# Download Code
echo -e "${BLUE}Downloading Code...${NC}"
wget -O /tmp/code.deb "$URL"

# Install Code
echo -e "${BLUE}Installing Code...${NC}"
sudo apt install -y /tmp/code.deb

echo -e "${GREEN}Code installation complete!${NC}"
