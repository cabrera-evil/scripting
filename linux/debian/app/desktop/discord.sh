#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://discord.com/api/download?platform=linux"

# Download Discord
echo -e "${BLUE}Downloading Discord...${NC}"
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux"

# Install Discord
echo -e "${BLUE}Installing Discord...${NC}"
sudo apt install -y /tmp/discord.deb

echo -e "${GREEN}Discord installation complete!${NC}"
