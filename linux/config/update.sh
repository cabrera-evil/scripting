#!/bin/bash

# Colors for terminal output
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[0;34m'
NC='\e[0m' # No Color

# Updating system
clear
echo -e "${blue}Updating System${NC}"
sudo apt-get update -y

# Upgrading packages
clear
echo -e "${blue}Upgrading Packages${NC}"
sudo apt-get upgrade -y

# Dist-upgrade
clear
echo -e "${blue}Dist-Upgrade${NC}"
sudo apt-get dist-upgrade -y

# Full-upgrade
clear
echo -e "${blue}Full-Upgrade${NC}"
sudo apt-get full-upgrade -y

# Autoremove packages
clear
echo -e "${blue}Autoremove Packages${NC}"
sudo apt autoremove -y

# Autoclean packages
clear
echo -e "${blue}Autoclean Packages${NC}"
sudo apt autoclean -y

# Fixing broken packages
clear
echo -e "${blue}Fixing Broken Packages${NC}"
sudo apt --fix-broken install -y
