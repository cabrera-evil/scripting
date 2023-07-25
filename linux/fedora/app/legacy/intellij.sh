#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
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

echo -e "${BLUE}Installing IntelliJ IDEA Ultimate...${NC}"
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y
handle_error $? "Flatpak install" "Failed to install IntelliJ IDEA Ultimate"
echo -e "${GREEN}IntelliJ IDEA Ultimate installed successfully!${NC}"
