#!/bin/bash

# Colors for terminal output
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[0;34m'
NC='\e[0m' # No Color

# Install NVM
clear
echo -e "${blue}Installing NVM...${NC}"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Export user config
clear
echo -e "${blue}Exporting user config...${NC}"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Reload config
clear
echo -e "${blue}Reloading config...${NC}"
source ~/.bashrc

# Install NodeJs LTS
clear
echo -e "${blue}Installing Node.js LTS...${NC}"
nvm i --lts && echo -e "${green}Node.js LTS installed.${NC}" || echo -e "${red}Failed to install Node.js LTS.${NC}"

# Install Modules
clear
echo -e "${blue}Installing Node.js modules...${NC}"
npm i -g typescript && echo -e "${green}Typescript installed.${NC}" || echo -e "${red}Failed to install Typescript.${NC}"
npm i -g sass && echo -e "${green}Sass installed.${NC}" || echo -e "${red}Failed to install Sass.${NC}"
npm i -g nodemon && echo -e "${green}Nodemon installed.${NC}" || echo -e "${red}Failed to install Nodemon.${NC}"
npm i -g vite && echo -e "${green}Vite installed.${NC}" || echo -e "${red}Failed to install Vite.${NC}"
npm i -g yarn && echo -e "${green}Yarn installed.${NC}" || echo -e "${red}Failed to install Yarn.${NC}"
npm i -g hbs && echo -e "${green}HBS installed.${NC}" || echo -e "${red}Failed to install HBS.${NC}"
npm i -g express-generator && echo -e "${green}Express generator installed.${NC}" || echo -e "${red}Failed to install Express generator.${NC}"
npm i -g create-electron-app && echo -e "${green}Create Electron App installed.${NC}" || echo -e "${red}Failed to install Create Electron App.${NC}"
npm i -g nest-api-generator && echo -e "${green}Nest API generator installed.${NC}" || echo -e "${red}Failed to install Nest API generator.${NC}"
