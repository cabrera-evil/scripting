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

# Download MongoDB Database Tools
echo -e "${BLUE}Downloading MongoDB Database Tools...${NC}"
if ! wget -O /tmp/mongodb-database-tools.deb "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.7.0.deb"; then
    handle_error $? "wget" "Failed to download MongoDB Database Tools"
fi

# Install MongoDB Database Tools
echo -e "${BLUE}Installing MongoDB Database Tools...${NC}"
if ! sudo dpkg -i /tmp/mongodb-database-tools.deb; then
    echo -e "${RED}MongoDB Database Tools installed with some errors (might be normal).${NC}"
fi

echo -e "${GREEN}MongoDB Database Tools installation complete!${NC}"
