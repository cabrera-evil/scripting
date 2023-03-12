#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEB='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install basic applications
clear
echo -e "${BLUE}Installing Basic Applications...${NC}"
sudo apt-get install htop -y
sudo apt-get install neofetch -y

# Install Git as version controller
clear
echo -e "${BLUE}Installing Git as version controller${NC}"
sudo apt-get install git -y
sudo apt-get install gnome-keyring -y

# Install Snap as additional software manager
clear
echo -e "${BLUE}Installing Snap as additional software manager${NC}"
sudo apt-get install snapd -y
