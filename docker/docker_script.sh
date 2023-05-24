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
print_header "Welcome to the installation menu."
echo -e "${YELLOW}What would you like to install?${NC}"
echo -e "${YELLOW}1. Docker desktop${NC}"
echo -e "${YELLOW}2. Docker engine${NC}"
echo -e "${YELLOW}3. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3):${NC} ")" choice

case $choice in
1)
    clear
    print_header "Installing Docker Desktop..."
    # Installing Docker Desktop
    sh ./docker/version/desktop.sh
    ;;
2)
    clear
    print_header "Installing Docker Engine..."
    # Installing Docker Engine
    sh ./docker/version/engine.sh
    ;;
3)
    clear
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter a valid number (1, 2, 3).${NC}"
    ;;
esac

# Return to the menu
sh "$0"
