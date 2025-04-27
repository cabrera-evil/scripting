#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.4/obsidian_1.8.4_${OS_ARCH}.deb"

# Download Obsidian
echo -e "${BLUE}Downloading Obsidian...${NC}"
wget -O /tmp/obsidian.deb "$URL"

# Install Obsidian
echo -e "${BLUE}Installing Obsidian...${NC}"
sudo apt install -y /tmp/obsidian.deb
