#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Updating system

echo -e "${BLUE}Updating System${NC}"
sudo apt-get update -y

# Upgrading packages
echo -e "${BLUE}Upgrading Packages${NC}"
sudo apt-get upgrade -y

# Dist-upgrade
echo -e "${BLUE}Dist-Upgrade${NC}"
sudo apt-get dist-upgrade -y

# Full-upgrade
echo -e "${BLUE}Full-Upgrade${NC}"
sudo apt-get full-upgrade -y

# Autoremove packages
echo -e "${BLUE}Autoremove Packages${NC}"
sudo apt autoremove -y

# Autoclean packages
echo -e "${BLUE}Autoclean Packages${NC}"
sudo apt autoclean -y

# Fixing broken packages
echo -e "${BLUE}Fixing Broken Packages${NC}"
sudo apt --fix-broken install -y
