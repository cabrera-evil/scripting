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

# Adding sudo user
echo -e "${BLUE}Adding sudo user${NC}"
sudo usermod -aG sudo $USER

# Checking if sudo user was added
echo -e "${BLUE}Checking if sudo user was added${NC}"
groups $USER | grep -q -w "sudo"

# Error handling
handle_error $? "groups $USER | grep -q -w \"sudo\"" "sudo user was not added"

echo -e "${GREEN}Sudo user was added${NC}"