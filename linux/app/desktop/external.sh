#!/bin/bash

# Colors for terminal output
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[0;34m'
NC='\e[0m' # No Color

# Install Termius
clear
echo -e "${blue}Downloading Termius...${NC}"
if ! wget -O /tmp/termius.deb "https://www.termius.com/download/linux/Termius.deb?_gl=1*i4xdht*_ga*MzQ0ODY0MDczLjE2MTY2MjI5ODE.*_ga_ZPQLW2Q816*MTY1NjM4MDU2Mi44My4xLjE2NTYzODIyNzguMA.." ; then
    echo -e "${red}Failed to download Termius.${NC}"
    exit 1
fi

echo -e "${blue}Installing Termius...${NC}"
if ! sudo dpkg -i /tmp/termius.deb ; then
    echo -e "${red}Failed to install Termius.${NC}"
    exit 1
fi

echo -e "${blue}Deleting Termius installation file...${NC}"
if ! sudo rm /tmp/termius.deb ; then
    echo -e "${yellow}Failed to delete Termius installation file.${NC}"
fi

echo -e "${green}Termius installation complete!${NC}"

# Install MongoDB Compass
echo -e "${blue}Downloading MongoDB Compass...${NC}"
if ! wget -O /tmp/mongodb_compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb" ; then
    echo -e "${red}Failed to download MongoDB Compass.${NC}"
    exit 1
fi

echo -e "${blue}Installing MongoDB Compass...${NC}"
if ! sudo dpkg -i /tmp/mongodb_compass.deb ; then
    echo -e "${red}Failed to install MongoDB Compass.${NC}"
    exit 1
fi

echo -e "${blue}Deleting MongoDB Compass installation file...${NC}"
if ! sudo rm /tmp/mongodb_compass.deb ; then
    echo -e "${yellow}Failed to delete MongoDB Compass installation file.${NC}"
fi

echo -e "${green}MongoDB Compass installation complete!${NC}"
