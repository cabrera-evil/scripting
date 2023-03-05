#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Print welcome message and menu
clear
echo -e "${YELLOW}Welcome to the installation menu.${NC}"
echo -e "${YELLOW}What would you like to install?${NC}"
echo -e "${YELLOW}1. Terminal apps only${NC}"
echo -e "${YELLOW}2. Terminal and desktop apps${NC}"
echo -e "${YELLOW}3. Change default grub${NC}"
echo -e "${YELLOW}4. Update system${NC}"
echo -e "${YELLOW}5. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    echo -e "${GREEN}Installing terminal apps...${NC}"
    # Updating System
    sudo sh ./config/update.sh
    # Installing terminal apps
    sudo sh ./app/terminal/apt.sh
    sudo sh ./app/terminal/dev.sh
    sudo sh ./app/terminal/npm.sh
    ;;
2)
    echo -e "${GREEN}Installing both terminal and desktop apps...${NC}"
    # Updating System
    sudo sh ./config/update.sh
    # Installing terminal apps
    sudo sh ./app/terminal/apt.sh
    sudo sh ./app/terminal/dev.sh
    sudo sh ./app/terminal/npm.sh
    # Install desktop apps
    sudo sh ./app/desktop/snap.sh
    sudo sh ./app/desktop/external.sh
    ;;
3)
    echo -e "${GREEN}Changing default grub...${NC}"
    # Change default grub
    sudo sh ./config/grub.sh
    ;;
4)
    echo -e "${GREEN}Updating system...${NC}"
    # Updating System
    sh ./config/update.sh
    ;;
5)
    echo -e "${GREEN}Exiting the installation menu...${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter 1, 2, 3, etc.${NC}"
    ;;
esac

# Return to the menu
sh "$0"
