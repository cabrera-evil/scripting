#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install snapd
echo -e "${BLUE}Installing snapd...${NC}"
sudo apt install snapd -y

# Install microk8s
echo -e "${BLUE}Installing microk8s...${NC}"
sudo snap install microk8s --classic

# Add user to microk8s group
echo -e "${BLUE}Adding user to microk8s group...${NC}"
sudo usermod -aG microk8s $USER

# Reload user groups
echo -e "${BLUE}Reloading user groups...${NC}"
newgrp microk8s

echo -e "${GREEN}Microk8s installed successfully!${NC}"
