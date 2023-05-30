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
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Add the alias to ~/.bashrc file
echo "alias code='flatpak run com.visualstudio.code'" >> ~/.bashrc
handle_error $? "echo" "Failed to add alias to ~/.bashrc."

# Reload the terminal configuration
source ~/.bashrc
handle_error $? "source" "Failed to reload terminal configuration."

# Download and install Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
handle_error $? "sudo rpm --import" "Failed to import Microsoft GPG key."

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
handle_error $? "sudo sh -c" "Failed to create vscode.repo file."

sudo dnf check-update
handle_error $? "sudo dnf check-update" "Failed to check for updates."

sudo dnf install code -y
handle_error $? "sudo dnf install" "Failed to install Visual Studio Code."

echo -e "${GREEN}Visual Studio Code alias added to ~/.bashrc, terminal configuration reloaded, and Visual Studio Code installed successfully!${NC}"
