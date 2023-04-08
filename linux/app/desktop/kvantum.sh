#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Kvantum
clear
echo -e "${BLUE}Installing Kvantum...${NC}"
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install --install-recommends kvantum
echo -e "${GREEN}Kvantum installed.${NC}"
