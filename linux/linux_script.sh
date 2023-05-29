#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}"
        exit $exit_code
    fi
}

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

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print welcome message and menu
print_header "Welcome to the installation menu."
echo -e "${YELLOW}Select your Linux distribution:${NC}"
echo -e "${YELLOW}1. Fedora${NC}"
echo -e "${YELLOW}2. Ubuntu${NC}"
echo -e "${YELLOW}3. Exit${NC}"

# Prompt user for Linux distribution choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3):${NC} ")" distro_choice

case $distro_choice in
1)
    distro_name="Fedora"
    distro_path="fedora"
    ;;
2)
    distro_name="Ubuntu"
    distro_path="ubuntu"
    ;;
3)
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    handle_error 1 "Invalid choice" "Please enter 1, 2, or 3."
    ;;
esac

# Print welcome message and menu
print_header "Welcome to the installation menu for $distro_name."
echo -e "${YELLOW}What would you like to install?${NC}"
echo -e "${YELLOW}1. Terminal apps only${NC}"
echo -e "${YELLOW}2. Terminal and desktop apps${NC}"
echo -e "${YELLOW}3. Desktop programs only${NC}"
echo -e "${YELLOW}4. Change default grub${NC}"
echo -e "${YELLOW}5. Update system${NC}"
echo -e "${YELLOW}6. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    print_header "Installing terminal apps..."

    # Installing terminal apps
    for script in $script_dir/$distro_path/app/terminal/*.sh; do
        source $script
        handle_error $? "Failed to install $script"
    done
    ;;
2)
    print_header "Installing both terminal and desktop apps..."

    # Installing terminal apps
    for script in $script_dir/$distro_path/app/terminal/*.sh; do
        source $script
        handle_error $? "Failed to install $script"
    done

    # Print available desktop programs
    print_header "Available desktop programs:"
    desktop_apps=($script_dir/$distro_path/app/desktop/*.sh)
    for script in "${desktop_apps[@]}"; do
        print_header "Installing $script..."
        source $script
        handle_error $? "Failed to install $script"
    done
    ;;
3)
    print_header "Installing desktop programs..."

    # Print available desktop programs
    print_header "Available desktop programs:"
    desktop_apps=($script_dir/$distro_path/app/desktop/*.sh)
    for ((i = 0; i < ${#desktop_apps[@]}; i++)); do
        app_script="${desktop_apps[$i]}"
        app_name=$(basename "$app_script" .sh)
        echo "$((i + 1)). $app_name"
    done

    # Prompt user for desktop program choice
    echo -e "${YELLOW}Which desktop program would you like to install?${NC}"
    echo -e "${YELLOW}Enter the program number (or 'all' to install all programs):${NC}"
    read -p "" app_choice

    if [[ "$app_choice" == "all" ]]; then
        # Install all desktop programs
        for script in "${desktop_apps[@]}"; do
            print_header "Installing $script..."
            source $script
            handle_error $? "Failed to install $script"
        done
    elif [[ "$app_choice" =~ ^[0-9]+$ ]]; then
        selected_app_script="${desktop_apps[$((app_choice - 1))]}"
        if [[ -n $selected_app_script ]]; then
            print_header "Installing $selected_app_script..."
            source "$selected_app_script"
            handle_error $? "Failed to install $selected_app_script"
        else
            handle_error 1 "Invalid choice" "Please select a valid program number."
        fi
    else
        handle_error 1 "Invalid choice" "Please enter a valid program number or 'all'."
    fi
    ;;
4)
    print_header "Updating default grub..."
    # Change default grub
    source $script_dir/$distro_path/config/grub.sh
    handle_error $? "Failed to update default grub."
    ;;
5)
    print_header "Updating system..."
    # Updating System
    sh $script_dir/$distro_path/config/update.sh
    handle_error $? "Failed to update system."
    ;;
6)
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    handle_error 1 "Invalid choice" "Please enter 1, 2, 3, etc."
    ;;
esac

# Return to the menu
exec bash "$0"
