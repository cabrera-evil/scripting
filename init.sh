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
echo -e "${YELLOW}3. Debian${NC}"
echo -e "${YELLOW}0. Exit${NC}"

# Prompt user for Linux distribution choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3):${NC} ")" distro_choice

case $distro_choice in
1)
    distro_name="Fedora"
    distro_path="linux/fedora"
    ;;
2)
    distro_name="Ubuntu"
    distro_path="linux/ubuntu"
    ;;
3)
    distro_name="Debian"
    distro_path="linux/debian"
    ;;
0)
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    handle_error 1 "Invalid choice" "Please enter 1, 2, 3..."
    ;;
esac

# Print welcome message and menu
print_header "Welcome to the installation menu for $distro_name."
echo -e "${YELLOW}What would you like to install?${NC}"
echo -e "${YELLOW}1. Update system${NC}"
echo -e "${YELLOW}2. Terminal apps only${NC}"
echo -e "${YELLOW}3. Desktop programs only${NC}"
echo -e "${YELLOW}4. Terminal and desktop apps${NC}"
echo -e "${YELLOW}5. Configure system${NC}"
echo -e "${YELLOW}0. Exit${NC}"

# Prompt user for choice
read -p "$(echo -e "${YELLOW}Enter your choice (1, 2, 3, etc):${NC} ")" choice

case $choice in
1)
    print_header "Updating system..."
    # Updating System
    $script_dir/$distro_path/config/update.sh
    handle_error $? "Failed to update system."
    ;;
2)

    print_header "Installing terminal apps..."

    # Installing terminal apps
    for script in $script_dir/$distro_path/app/terminal/*.sh; do
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

    # Prompt user for desktop program choices
    echo -e "${YELLOW}Which desktop programs would you like to install?${NC}"
    echo -e "${YELLOW}Enter the program numbers separated by commas (e.g., '1,3,5') or 'all' to install all programs:${NC}"
    read -p "" app_choices

    IFS=',' read -ra selected_indices <<<"$app_choices"

    for index in "${selected_indices[@]}"; do
        if [[ "$app_choices" == "all" ]]; then
            # Install all desktop programs
            for script in "${desktop_apps[@]}"; do
                print_header "Installing $script..."
                source "$script"
                handle_error $? "Failed to install $script"
            done
        elif [[ "$index" =~ ^[0-9]+$ ]]; then
            selected_app_script="${desktop_apps[$((index - 1))]}"
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
    done
    ;;
4)
    print_header "Installing both terminal and desktop apps..."

    # Installing terminal apps
    for script in $script_dir/$distro_path/app/terminal/*.sh; do
        source $script
        handle_error $? "Failed to install $script"
    done

    # Print available desktop programs
    print_header "Available desktop programs:"
    desktop_apps=($script_dir/$distro_path/app/desktop/*.sh)
    for ((i = 0; i < ${#desktop_apps[@]}; i++)); do
        app_script="${desktop_apps[$i]}"
        app_name=$(basename "$app_script" .sh)
        echo "$((i + 1)). $app_name"
    done

    # Prompt user for desktop program choices
    echo -e "${YELLOW}Which desktop programs would you like to install?${NC}"
    echo -e "${YELLOW}Enter the program numbers separated by commas (e.g., '1,3,5') or 'all' to install all programs:${NC}"
    read -p "" app_choices

    IFS=',' read -ra selected_indices <<<"$app_choices"

    for index in "${selected_indices[@]}"; do
        if [[ "$app_choices" == "all" ]]; then
            # Install all desktop programs
            for script in "${desktop_apps[@]}"; do
                print_header "Installing $script..."
                source "$script"
                handle_error $? "Failed to install $script"
            done
        elif [[ "$index" =~ ^[0-9]+$ ]]; then
            selected_app_script="${desktop_apps[$((index - 1))]}"
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
    done
    ;;
5)
    print_header "Configuring applications..."

    # Print available configure scripts
    print_header "Available configure scripts:"
    config_scripts=($script_dir/$distro_path/config/*.sh)
    for ((i = 0; i < ${#config_scripts[@]}; i++)); do
        script="${config_scripts[$i]}"
        script_name=$(basename "$script" .sh)
        echo "$((i + 1)). $script_name"
    done

    # Prompt user for configure script choice
    echo -e "${YELLOW}Which configure script would you like to run?${NC}"
    echo -e "${YELLOW}Enter the script number (or 'all' to run all scripts):${NC}"
    read -p "" script_choice

    if [[ "$script_choice" == "all" ]]; then
        # Run all configure scripts
        for script in "${config_scripts[@]}"; do
            print_header "Running $script..."
            source $script
            handle_error $? "Failed to run $script"
        done
    elif [[ "$script_choice" =~ ^[0-9]+$ ]]; then
        selected_script="${config_scripts[$((script_choice - 1))]}"
        if [[ -n $selected_script ]]; then
            print_header "Running $selected_script..."
            source "$selected_script"
            handle_error $? "Failed to run $selected_script"
        else
            handle_error 1 "Invalid choice" "Please select a valid script number."
        fi
    else
        handle_error 1 "Invalid choice" "Please enter a valid script number or 'all'."
    fi
    ;;
0)
    print_header "Exiting the installation menu..."
    exit 0
    ;;
*)
    handle_error 1 "Invalid choice" "Please enter 1, 2, 3, etc."
    ;;
esac

# Return to the menu
exec bash "$0"
