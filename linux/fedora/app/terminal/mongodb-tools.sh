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

# Download MongoDB Database Tools
echo -e "${BLUE}Downloading MongoDB Database Tools...${NC}"
wget -O /tmp/mongodb-database-tools.rpm "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel90-x86_64-100.7.3.rpm"
handle_error $? "wget" "Failed to download MongoDB Database Tools."

# Install MongoDB Database Tools
echo -e "${BLUE}Installing MongoDB Database Tools...${NC}"
sudo rpm -i /tmp/mongodb-database-tools.rpm
handle_error $? "sudo rpm -i" "Failed to install MongoDB Database Tools."

echo -e "${GREEN}MongoDB Database Tools installation complete!${NC}"
