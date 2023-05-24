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
echo -e "${YELLOW}1. Terminal apps only${NC}"
echo -e "${YELLOW}2. Terminal and desktop apps${NC}"
echo -e "${YELLOW}3. Change default grub${NC}"
echo -e "${YELLOW}4. Update system${NC}"
echo -e "${YELLOW}5. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    clear
    print_header "Installing terminal apps..."
    # Updating System
    sudo sh ./linux/config/update.sh

    # Installing terminal apps
    for script in ./linux/app/terminal/*.sh; do
        sudo sh "$script"
    done
    ;;
2)
    clear
    print_header "Installing both terminal and desktop apps..."
    # Updating System
    sudo sh ./linux/config/update.sh

    # Installing terminal apps
    for script in ./linux/app/terminal/*.sh; do
        sudo sh "$script"
    done

    # Print available desktop programs
    print_header "Available desktop programs:"
    desktop_apps=(./linux/app/desktop/*.sh)
    for ((i = 0; i < ${#desktop_apps[@]}; i++)); do
        app_script="${desktop_apps[$i]}"
        app_name=$(basename "$app_script" .sh)
        echo "$((i + 1)). $app_name"
    done

    # Prompt user for desktop program choice
    echo -e "${YELLOW}Which desktop program would you like to install?${NC}"
    read -p "$(echo -e "${YELLOW}Enter the program number (or 'all' to install all programs):${NC} ")" app_choice

    if [[ "$app_choice" == "all" ]]; then
        # Install all desktop programs
        for script in "${desktop_apps[@]}"; do
            print_header "Installing ${script}..."
            sudo sh "$script"
        done
    elif [[ "$app_choice" =~ ^[0-9]+$ ]]; then
        selected_app_script="${desktop_apps[$((app_choice - 1))]}"
        if [[ -n $selected_app_script ]]; then
            print_header "Installing ${selected_app_script}..."
            sudo sh "$selected_app_script"
        else
            echo -e "${RED}Invalid choice. Please select a valid program number.${NC}"
        fi
    else
        echo -e "${RED}Invalid choice. Please enter a valid program number or 'all'.${NC}"
    fi
    ;;
3)
    clear
    print_header "Updating default grub..."
    # Change default grub
    sudo sh ./linux/config/grub.sh
    ;;
4)
    clear
    print_header "Updating system..."
    # Updating System
    sh ./linux/config/update.sh
    ;;
5)
    clear
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Please enter 1, 2, 3, etc.${NC}"
    ;;
esac

# Return to the menu
sh "$0"
