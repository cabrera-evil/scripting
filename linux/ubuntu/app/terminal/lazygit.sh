#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Get latest lazygit version
echo -e "${BLUE}Fetching latest Lazygit version...${NC}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Download lazygit
echo -e "${BLUE}Downloading Lazygit v${LAZYGIT_VERSION}...${NC}"
wget -O /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${OS_ARCH_RAW}.tar.gz"

# Extract and install
echo -e "${BLUE}Extracting Lazygit...${NC}"
tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit

echo -e "${BLUE}Installing Lazygit...${NC}"
sudo install /tmp/lazygit -D -t /usr/local/bin/

echo -e "${GREEN}Lazygit installation completed successfully.${NC}"
