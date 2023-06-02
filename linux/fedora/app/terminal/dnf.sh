#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install basic applications
echo -e "${BLUE}Installing Basic Applications...${NC}"
sudo dnf install htop -y
sudo dnf install neofetch -y

# Install Git as version controller
echo -e "${BLUE}Installing Git as version controller${NC}"
sudo dnf install git -y
sudo dnf install gnome-keyring -y

# Install basic development tools
echo -e "${BLUE}Installing Basic Development Tools...${NC}"
sudo dnf install @development-tools -y

# Install docker-compose
echo -e "${BLUE}Installing docker-compose...${NC}"
sudo dnf install docker-compose -y

# Install ark as archive manager
echo -e "${BLUE}Installing ark as archive manager...${NC}"
sudo dnf install ark -y
