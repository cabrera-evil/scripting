#!/bin/bash

# Colors for terminal output
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[0;34m'
NC='\e[0m' # No Color

# Install Snap Applications
clear
echo -e "${blue}Installing Snap Applications...${NC}"
sudo snap install spotify && echo -e "${green}Spotify installed.${NC}" || echo -e "${red}Failed to install Spotify.${NC}"
sudo snap install discord && echo -e "${green}Discord installed.${NC}" || echo -e "${red}Failed to install Discord.${NC}"
sudo snap install postman && echo -e "${green}Postman installed.${NC}" || echo -e "${red}Failed to install Postman.${NC}"
sudo snap install code --classic && echo -e "${green}Visual Studio Code installed.${NC}" || echo -e "${red}Failed to install Visual Studio Code.${NC}"
sudo snap install android-studio --classic && echo -e "${green}Android Studio installed.${NC}" || echo -e "${red}Failed to install Android Studio.${NC}"
