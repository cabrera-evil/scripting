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
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Reload bash
echo -e "${BLUE}Reloading bash...${NC}"
source ~/.nvm/nvm.sh

# Install Node.js LTS
echo -e "${BLUE}Installing Node.js LTS...${NC}"
nvm install --lts

# Set default Node.js version
echo -e "${BLUE}Setting default Node.js version...${NC}"
nvm use --lts

# Install the latest npm version
echo -e "${BLUE}Installing the latest npm version...${NC}"
npm install -g npm@latest

# Install npm packages
echo -e "${BLUE}Installing npm packages...${NC}"
npm install -g yarn pnpm pm2 @nestjs/cli nodemon express-generator

echo -e "${GREEN}NVM installation completed successfully.${NC}"
