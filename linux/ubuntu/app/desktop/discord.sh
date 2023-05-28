#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Discord
clear
echo -e "${BLUE}Downloading Discord...${NC}"
if ! wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"; then
    echo -e "${RED}Failed to download Discord.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing Discord...${NC}"
if ! sudo dpkg -i /tmp/discord.deb; then
    echo -e "${RED}Discord installed with some errors (might be normal).${NC}"
fi

echo -e "${GREEN}Discord installation complete!${NC}"
