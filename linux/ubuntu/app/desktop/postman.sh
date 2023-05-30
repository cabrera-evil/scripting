#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Snap as additional software manager
echo -e "${BLUE}Installing Snap as additional software manager${NC}"
sudo apt-get install snapd -y

# Install Postman from Snap
echo -e "${BLUE}Installing Snap Applications...${NC}"
sudo snap install postman && echo -e "${GREEN}Postman installed.${NC}" || echo -e "${RED}Failed to install Postman.${NC}"