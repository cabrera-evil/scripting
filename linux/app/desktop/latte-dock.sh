#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Latte Dock
clear
echo -e "${BLUE}Installing Latte Dock...${NC}"
sudo apt-get update
sudo apt-get install -y latte-dock
echo -e "${GREEN}Latte Dock installed.${NC}"
