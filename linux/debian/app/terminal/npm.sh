#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install NVM
echo -e "${BLUE}Installing NVM (Node Version Manager)...${NC}"
if ! [ -x "$(command -v wget)" ]; then
    echo -e "${YELLOW}Wget is not installed, installing...${NC}"
    sudo apt install wget -y

fi
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Reload bash
echo -e "${BLUE}Reloading bash...${NC}"
source ~/.nvm/nvm.sh

# Install Node.js LTS
echo -e "${BLUE}Installing Node.js LTS...${NC}"
nvm install --lts

# Set default Node.js version
echo -e "${BLUE}Setting default Node.js version...${NC}"
nvm use --lts

# Install npm packages
echo -e "${BLUE}Installing npm packages...${NC}"
npm install -g npm@latest yarn@latest pnpm@latest 

echo -e "${GREEN}NVM installation completed successfully.${NC}"
