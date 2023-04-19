#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install GNS3
clear
echo -e "${BLUE}Installing GNS3...${NC}"
sudo add-apt-repository ppa:gns3/ppa -y
sudo apt update                                
sudo apt install gns3-gui gns3-server -y
echo -e "${GREEN}GNS3 installed.${NC}"