#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Print welcome message and menu
echo -e "${YELLOW}Welcome to the installation menu.${NC}"
echo -e "${YELLOW}What would you like to install?${NC}"
echo -e "${YELLOW}1. Docker desktop${NC}"
echo -e "${YELLOW}2. Docker engine${NC}"
echo -e "${YELLOW}3. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3):${NC} ")" choice

case $choice in
1)
    echo -e "${GREEN}Installing docker desktop...${NC}"
    # Installing docker desktop
    sh ./docker/version/desktop.sh
    ;;
2)
    echo -e "${GREEN}Installing docker engine...${NC}"
    # Installing docker engine
    sh ./docker/version/engine.sh
    ;;
3)
    echo -e "${GREEN}Exiting the installation menu...${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter 1, 2, 3.${NC}"
    ;;
esac

# Return to the menu
sh "$0"