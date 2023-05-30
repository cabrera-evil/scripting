#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Code
echo -e "${BLUE}Downloading Code...${NC}"
if ! wget -O /tmp/code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; then
    echo -e "${RED}Failed to download Code.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing Code...${NC}"
if ! sudo dpkg -i /tmp/code.deb; then
    echo -e "${RED}Failed to install Code.${NC}"
    exit 1
fi

echo -e "${GREEN}Code installation complete!${NC}"