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
    local success_message=$3
    local error_message=$4

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}$success_message${NC}"
    else
        echo -e "${RED}$error_message${NC}"
        exit $exit_code
    fi
}

# Install Snap as additional software manager
echo -e "${BLUE}Installing Snap as additional software manager${NC}"
sudo apt-get install snapd -y
handle_error $? "Installing Snap" "Snap installed." "Failed to install Snap."

# Install Postman from Snap
echo -e "${BLUE}Installing Snap Applications...${NC}"
sudo snap install postman
handle_error $? "Installing Postman" "Postman installed." "Failed to install Postman."
