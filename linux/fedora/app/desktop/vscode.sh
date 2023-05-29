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

echo -e "${GREEN}Visual Studio Code alias added to ~/.bashrc and terminal configuration reloaded successfully!${NC}"
