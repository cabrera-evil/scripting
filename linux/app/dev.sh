#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Install Proton dependencies
clear
echo -e "${YELLOW}Installing Proton dependencies...${NC}"
sudo apt-get install -y libgbm-dev

# Install basic development tools
clear
echo -e "${YELLOW}Installing Basic Development Tools...${NC}"
sudo apt-get install build-essential -y

# Install Java
clear
echo -e "${YELLOW}Installing Java...${NC}"
sudo apt-get install default-jdk -y
sudo apt-get install default-jre -y

# Print success message
echo -e "${GREEN}Proton dependencies and development tools installed successfully.${NC}"
