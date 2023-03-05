#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Print welcome message and menu
clear
echo -e "${YELLOW}Welcome to the scripting menu.${NC}"
echo -e "${YELLOW}What would you like to do?${NC}"
echo -e "${YELLOW}1. Docker scripts${NC}"
echo -e "${YELLOW}2. Github scripts${NC}"
echo -e "${YELLOW}3. Linux scripts${NC}"
echo -e "${YELLOW}4. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    echo -e "${GREEN}Opening docker script menu...${NC}"
    # Docker scripts menu
    sh ./docker/init.sh
    ;;
2)
    echo -e "${GREEN}Opening github script menu...${NC}"
    # Github scripts menu
    sh ./github/init.sh
    ;;
3)
    echo -e "${GREEN}Opening linux script menu...${NC}"
    # Change default grub
    sh ./linux/init.sh
    ;;
4)
    echo -e "${GREEN}Exiting the installation menu...${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter 1, 2, 3, etc.${NC}"
    ;;
esac

# Return to the menu
sh "$0"