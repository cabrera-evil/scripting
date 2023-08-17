#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Install i3
echo -e "${YELLOW}Installing i3${NC}"
sudo apt install -y i3
handle_error $? "sudo apt install -y i3" "i3 was not installed"

echo -e "${GREEN}i3 was installed${NC}"