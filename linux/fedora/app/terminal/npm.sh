#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install NVM
clear
echo -e "${BLUE}Installing NVM...${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Export user config
echo -e "${BLUE}Exporting user config...${NC}"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Reload config
echo -e "${BLUE}Reloading config...${NC}"
source ~/.bashrc

# Install Node.js LTS
echo -e "${BLUE}Installing Node.js LTS...${NC}"
nvm install --lts && echo -e "${GREEN}Node.js LTS installed.${NC}" || echo -e "${RED}Failed to install Node.js LTS.${NC}"

# Install Modules
echo -e "${BLUE}Installing Node.js modules...${NC}"
npm install -g typescript && echo -e "${GREEN}Typescript installed.${NC}" || echo -e "${RED}Failed to install Typescript.${NC}"
npm install -g nodemon && echo -e "${GREEN}Nodemon installed.${NC}" || echo -e "${RED}Failed to install Nodemon.${NC}"
npm install -g vite && echo -e "${GREEN}Vite installed.${NC}" || echo -e "${RED}Failed to install Vite.${NC}"
npm install -g hbs && echo -e "${GREEN}HBS installed.${NC}" || echo -e "${RED}Failed to install HBS.${NC}"
npm install -g create-electron-app && echo -e "${GREEN}Create Electron App installed.${NC}" || echo -e "${RED}Failed to install Create Electron App.${NC}"
npm install -g express-generator && echo -e "${GREEN}Express generator installed.${NC}" || echo -e "${RED}Failed to install Express generator.${NC}"
npm install -g @nestjs/cli && echo -e "${GREEN}NestJS CLI installed.${NC}" || echo -e "${RED}Failed to install NestJS CLI.${NC}"
npm install -g http-server && echo -e "${GREEN}HTTP Server installed.${NC}" || echo -e "${RED}Failed to install HTTP Server.${NC}"
