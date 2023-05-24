#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print a separator line
print_separator() {
    echo -e "${YELLOW}==============================================${NC}"
}

# Function to print a header
print_header() {
    print_separator
    echo -e "${YELLOW}$1${NC}"
    print_separator
}

# Print welcome message and menu
clear
print_header "Welcome to the scripting menu."
echo -e "${YELLOW}What would you like to do?${NC}"
echo -e "${YELLOW}1. Docker scripts${NC}"
echo -e "${YELLOW}2. Github scripts${NC}"
echo -e "${YELLOW}3. Linux scripts${NC}"
echo -e "${YELLOW}4. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    clear
    print_header "Opening Docker script menu..."
    # Docker scripts menu
    sh ./docker/docker_script.sh
    ;;
2)
    clear
    print_header "Opening Github script menu..."
    # Github scripts menu
    sh ./github/github_script.sh
    ;;
3)
    clear
    print_header "Opening Linux script menu..."
    # Linux scripts menu
    sh ./linux/linux_script.sh
    ;;
4)
    clear
    print_header "Exiting the scripting menu..."
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter a valid number (1, 2, 3, etc).${NC}"
    ;;
esac

# Return to the menu
sh "$0"
