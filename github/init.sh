#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Print welcome message and menu
clear
echo -e "${YELLOW}Welcome to github scripting menu.${NC}"
echo -e "${YELLOW}What would you like to do?${NC}"
echo -e "${YELLOW}1. Clone a repository${NC}"
echo -e "${YELLOW}2. Create a repository${NC}"
echo -e "${YELLOW}3. Delete a repository${NC}"
echo -e "${YELLOW}4. Reset a repository${NC}"
echo -e "${YELLOW}5. Setup gitconfig${NC}"
echo -e "${YELLOW}6. Setup git credential manager (linux)${NC}"
echo -e "${YELLOW}7. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, 4, 5):${NC} ")" choice

case $choice in
1)
    echo -e "${GREEN}Cloning a repository...${NC}"
    # Cloning a github repository
    sh ./scripts/clone_repo.sh
    ;;
2)
    echo -e "${GREEN}Creating a repository...${NC}"
    # Creating a github repository
    sh ./scripts/create_repo.sh
    ;;
3)
    echo -e "${GREEN}Deleting a repository...${NC}"
    # Deleting a github repository
    sh ./scripts/delete_repo.sh
    ;;
4)
    echo -e "${GREEN}Resetting a repository...${NC}"
    # Resetting a github repository
    sh ./scripts/reset_repo.sh
    ;;
5)
    echo -e "${GREEN}Setting up gitconfig...${NC}"
    # Setting up gitconfig
    sh ./scripts/git_config.sh
    ;;
6)
    echo -e "${GREEN}Setting up git credential manager (linux)...${NC}"
    # Setting up git credential manager (linux)
    sh ./scripts/gcm_config.sh
    ;;
7)
    echo -e "${GREEN}Exiting the github scripting menu...${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter 1, 2, 3.${NC}"
    ;;
esac

# Return to the menu
sh "$0"