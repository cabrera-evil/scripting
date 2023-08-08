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

# Install SaveDesktop via Flatpak
echo -e "${BLUE}Installing SaveDesktop...${NC}"
flatpak install flathub io.github.vikdevelop.SaveDesktop -y
handle_error $? "Failed to install SaveDesktop."

echo -e "${GREEN}SaveDesktop installation complete!${NC}"
