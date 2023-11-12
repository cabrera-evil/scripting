#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
distro_name=""
distro_path=""
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print distro logo ASCII art
print_linux() {
    cat <<"EOF"
         _nnnn_                      
        dGGGGMMb     ,"""""""""""""".
       @p~qp~~qMb    | Linux Rules! |
       M|@||@) M|   _;..............'
       @,----.JM| -'
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMM|   .'
     `-'       `--'
EOF
}

# Function to print header
print_header() {
    clear
    printf "${BLUE}%s${NC}\n" "$1"
}

# Function to handle errors
handle_error() {
    # Define your error handling logic here
    echo -e "${RED}Error: $2 - $3"

    # Print press any key to continue
    read -n 1 -s -r -p "Press any key to continue..."

    # Exit the script
    exit "$1"
}

# Function to start the installation menu
start_menu() {
    print_header "Welcome to the installation menu."
    print_linux
    printf "Select your Linux distribution:${NC}\n"
    printf "1. Fedora${NC}\n"
    printf "2. Ubuntu${NC}\n"
    printf "3. Debian${NC}\n"
    printf "0. Exit${NC}\n"

    # Prompt user for Linux distribution choice
    read -p "$(printf "Enter your choice (1, 2, 3):${NC} ")" distro_choice

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
}

# Function for the installation menu for a specific distribution
distro_menu() {
    while true; do
        print_header "Welcome to the installation menu for $distro_name."
        printf "What would you like to install?${NC}\n"
        printf "1. Update system${NC}\n"
        printf "2. Terminal apps only${NC}\n"
        printf "3. Desktop programs only${NC}\n"
        printf "4. Terminal and desktop apps${NC}\n"
        printf "5. Configure system${NC}\n"
        printf "0. Exit${NC}\n"

        # Prompt user for choice
        read -p "$(printf "Enter your choice (1, 2, 3, etc):${NC} ")" choice

        case $choice in
        1) update_system ;;
        2) install_terminal_apps ;;
        3) install_desktop_programs ;;
        4)
            install_terminal_apps
            install_desktop_programs
            ;;
        5) config_system ;;
        0)
            print_header "Exiting the installation menu for $distro_name..."
            break
            ;;
        *)
            handle_error 1 "Invalid choice" "Please enter 1, 2, 3, etc..."
            ;;
        esac

        # Wait for user input before returning to the distro menu
        read -n 1 -s -r -p "Press any key to continue..."
    done
}

# Helper functions

# Function to update the system
update_system() {
    $script_dir/$distro_path/config/update.sh
    handle_error $? "Failed to update system."
}

# Function to install terminal apps
install_terminal_apps() {
    print_header "Available terminal programs:"
    script_list=($script_dir/$distro_path/app/terminal/*.sh)
    for ((i = 0; i < ${#script_list[@]}; i++)); do
        app_script="${script_list[$i]}"
        app_name=$(basename "$app_script" .sh)
        echo "$((i + 1)). $app_name"
    done

    # Prompt user for terminal program choices
    echo -e "${YELLOW}Which terminal programs would you like to install?${NC}"
    echo -e "${YELLOW}Enter the program numbers separated by commas (e.g., '1,3,5'), 'all' to install all programs, or '0' to exit:${NC}"
    read -p "" script_choice

    IFS=',' read -ra selected_indices <<<"$script_choice"

    prompt_menu
}

# Function to install desktop programs
install_desktop_programs() {
    print_header "Available desktop programs:"
    script_list=($script_dir/$distro_path/app/desktop/*.sh)
    for ((i = 0; i < ${#script_list[@]}; i++)); do
        app_script="${script_list[$i]}"
        app_name=$(basename "$app_script" .sh)
        echo "$((i + 1)). $app_name"
    done

    # Prompt user for desktop program choices
    echo -e "${YELLOW}Which desktop programs would you like to install?${NC}"
    echo -e "${YELLOW}Enter the program numbers separated by commas (e.g., '1,3,5'), 'all' to install all programs, or '0' to exit:${NC}"
    read -p "" script_choice

    IFS=',' read -ra selected_indices <<<"$script_choice"

    prompt_menu
}

prompt_menu() {
    for index in "${selected_indices[@]}"; do
        if [[ "$index" == "0" ]]; then
            echo -e "${BLUE}Nothing to do...${NC}"
            break
        fi
        if [[ "$script_choice" == "all" ]]; then
            # Install all desktop programs
            for script in "${script_list[@]}"; do
                source "$script"
                handle_error $? "Failed to install $script"
            done
        elif [[ "$index" =~ ^[0-9]+$ ]]; then
            selected_script="${script_list[$((index - 1))]}"
            if [[ -n $selected_script ]]; then
                source "$selected_script"
                handle_error $? "Failed to install $selected_script"
            else
                handle_error 1 "Invalid choice" "Please select a valid program number."
            fi
        else
            handle_error 1 "Invalid choice" "Please enter a valid program number or 'all'."
        fi
    done
}

# Function to configure the system
config_system() {
    print_header "Available configure scripts:"
    script_list=($script_dir/$distro_path/config/*.sh)
    for ((i = 0; i < ${#script_list[@]}; i++)); do
        script="${script_list[$i]}"
        script_name=$(basename "$script" .sh)
        echo "$((i + 1)). $script_name"
    done

    # Prompt user for configure script choice
    echo -e "${YELLOW}Which configure script would you like to run?${NC}"
    echo -e "${YELLOW}Enter the script number (e.g., '1,3,5'), 'all' to install all programs, or '0' to exit:${NC}"
    read -p "" script_choice

    IFS=',' read -ra selected_indices <<<"$script_choice"

    prompt_menu
}

# Main function
main() {
    # Start the installation menu
    start_menu

    # Start the installation menu for a specific distribution
    distro_menu
}

# Main loop
while true; do
    main
done
