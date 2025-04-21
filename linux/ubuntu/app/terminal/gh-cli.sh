#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Create directory for keyrings
echo -e "${BLUE}Creating directory for keyrings...${NC}"
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download GitHub CLI archive keyring
echo -e "${BLUE}Downloading GitHub CLI archive keyring...${NC}"
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

# Set permissions on keyring file
echo -e "${BLUE}Setting permissions on keyring...${NC}"
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add GitHub CLI repository to APT sources
echo -e "${BLUE}Adding GitHub CLI repository...${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

# Update package lists
echo -e "${BLUE}Updating APT package list...${NC}"
sudo apt update

# Install GitHub CLI
echo -e "${BLUE}Installing GitHub CLI...${NC}"
sudo apt install gh -y

echo -e "${GREEN}GitHub CLI installation complete!${NC}"
