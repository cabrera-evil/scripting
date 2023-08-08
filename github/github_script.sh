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
    clear
    print_separator
    echo -e "${YELLOW}$1${NC}"
    print_separator
}

# Print welcome message and menu
print_header "Welcome to the GitHub scripting menu."
echo -e "${YELLOW}What would you like to do?${NC}"
echo -e "${YELLOW}1. Clone a repository${NC}"
echo -e "${YELLOW}2. Create a repository${NC}"
echo -e "${YELLOW}3. Delete a repository${NC}"
echo -e "${YELLOW}4. Reset a repository${NC}"
echo -e "${YELLOW}5. Setup gitconfig${NC}"
echo -e "${YELLOW}6. Setup ssh${NC}"
echo -e "${YELLOW}7. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, 4, 5, 6, 7):${NC} ")" choice

case $choice in
1)
    print_header "Cloning a repository..."
    # Cloning a GitHub repository
    ./github/scripts/clone_repo.sh
    ;;
2)
    print_header "Creating a repository..."
    # Creating a GitHub repository
    ./github/scripts/create_repo.sh
    ;;
3)
    print_header "Deleting a repository..."
    # Deleting a GitHub repository
    ./github/scripts/delete_repo.sh
    ;;
4)
    print_header "Resetting a repository..."
    # Resetting a GitHub repository
    ./github/scripts/reset_repo.sh
    ;;
5)
    print_header "Setting up gitconfig..."
    # Setting up gitconfig
    ./github/scripts/git_config.sh
    ;;
6)
    print_header "Setting up git credential manager (Linux)..."
    # Setting up git credential manager (Linux)
    ./github/scripts/ssh_config.sh
    ;;
7)
    print_header "Exiting the GitHub scripting menu..."
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter a valid number (1, 2, 3, 4, 5, 6, 7).${NC}"
    ;;
esac

# Return to the menu
sh "$0"
