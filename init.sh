#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
distro_name=$(. /etc/os-release && echo "$ID")
distro_path="linux/$distro_name"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to exit the script
function ctrl_c() {
    echo -e "${RED}Exiting...${NC}"
    exit 1
}

# Error handling function
function handle_error() {
    local exit_code=$1
    local command="${BASH_COMMAND}"

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: Command \"${command}\" failed with exit code ${exit_code}${NC}"
        exit 1
    fi
}

# Trap events
trap ctrl_c INT
trap 'handle_error $?' ERR

# Function to handle not found errors
handle_not_found() {
    echo -e "${RED}Error: $2 - $3"
    read -n 1 -s -r -p "Press any key to continue..."
    exit "$1"
}

# Function to print header
title() {
    clear
    echo -e "${BLUE}$1${NC}"
    cat <<"EOF"
                                 ,        ,
                                /(        )`
                                \ \___   / |
                                /- _  `-/  '
                               (/\/ \ \   /\
                               / /   | `    \
                               O O   ) /    |
                               `-^--'`<     '
                   TM         (_.)  _  )   /
|  | |\  | ~|~ \ /             `.___/`    /
|  | | \ |  |   X                `-----' /
`__| |  \| _|_ / \  <----.     __ / __   \
                    <----|====O)))==) \) /====
                    <----'    `--' `.__,' \
                                 |        |
                                  \       /
                             ______( (_  / \______
                           ,'  ,-----'   |        \
                           `--{__________)        \/
EOF
}

# Function for the installation menu for a specific distribution
menu() {
    while true; do
        title "Welcome to the installation menu for $distro_name."
        echo "What would you like to install?"
        echo "1. Update system"
        echo "2. Terminal apps only"
        echo "3. Desktop programs only"
        echo "4. Terminal and desktop apps"
        echo "5. Configure system"
        echo "0. Exit"
        read -p "$(echo "Enter your choice (1, 2, 3, etc): ")" choice
        case $choice in
        1) update ;;
        2) show_terminal ;;
        3) show_desktop ;;
        4)
            show_terminal
            show_desktop
            ;;
        5) show_config ;;
        0)
            title "Exiting the installation menu for $distro_name..."
            break
            ;;
        *)
            handle_not_found 1 "Invalid choice" "Please enter 1, 2, 3, etc..."
            ;;
        esac
        read -n 1 -s -r -p "Press any key to continue..."
    done
}

# Function to update the system
update() {
    $dir/$distro_path/config/update.sh
}

# Generic function to handle installation and configuration
handle_scripts() {
    local action_type=$1
    local script_subdir=$2
    local script_desc=$3
    title "Available $script_desc scripts:"
    script_list=($dir/$distro_path/$script_subdir/*.sh)
    for ((i = 0; i < ${#script_list[@]}; i++)); do
        script="${script_list[$i]}"
        script_name=$(basename "$script" .sh)
        echo "$((i + 1)). $script_name"
    done
    echo -e "${YELLOW}Which $script_desc scripts would you like to $action_type?${NC}"
    echo -e "${YELLOW}Enter the script numbers separated by commas (e.g., '1,3,5'), 'all' to select all scripts, or '0' to exit:${NC}"
    read -p "" script_choice
    IFS=',' read -ra selected_indices <<<"$script_choice"
    install_selected
}

# Function to prompt the user to select a program
install_selected() {
    for index in "${selected_indices[@]}"; do
        if [[ "$index" == "0" ]]; then
            echo -e "${BLUE}Nothing to do...${NC}"
            break
        elif [[ "$script_choice" == "all" ]]; then
            for script in "${script_list[@]}"; do
                source "$script"
            done
            break
        fi
        if [[ "$index" =~ ^[0-9]+$ ]]; then
            selected_script="${script_list[$((index - 1))]}"
            if [[ -n $selected_script ]]; then
                source "$selected_script"
            else
                handle_not_found 1 "Invalid choice" "Please select a valid program number."
            fi
        elif [[ "$index" =~ ^[0-9]+-[0-9]+$ ]]; then
            IFS='-' read -ra range <<<"$index"
            start=${range[0]}
            end=${range[1]}
            if [[ "$start" -le "$end" ]]; then
                for ((i = start; i <= end; i++)); do
                    selected_script="${script_list[$((i - 1))]}"
                    if [[ -n $selected_script ]]; then
                        source "$selected_script"
                    else
                        handle_not_found 1 "Invalid range" "Please select a valid range of program numbers."
                    fi
                done
            else
                handle_not_found 1 "Invalid range" "The start of the range cannot be greater than the end."
            fi
        else
            handle_not_found 1 "Invalid choice" "Please enter a valid program number, range, or 'all'."
        fi
    done
}

# Function to install terminal programs
show_terminal() {
    handle_scripts "install" "app/terminal" "terminal program"
}

# Function to install desktop programs
show_desktop() {
    handle_scripts "install" "app/desktop" "desktop program"
}

# Function to configure the system
show_config() {
    handle_scripts "configure" "config" "configure"
}

# Main function
main() {
    if [ ! -d "$dir/$distro_path" ]; then
        echo -e "${RED}Error: $distro_name is not supported.${NC}"
        exit 1
    fi
    menu
}

# Main loop
while true; do
    main
done
