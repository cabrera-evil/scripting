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

# Download DBeaver Community Edition
download_url="https://download.dbeaver.com/community/23.1.3/dbeaver-ce_23.1.3_amd64.deb"
download_file="/tmp/dbeaver.deb"

echo -e "${BLUE}Downloading DBeaver Community Edition...${NC}"
if ! curl -L "$download_url" -o "$download_file"; then
    handle_error 1 "curl" "Failed to download DBeaver Community Edition DEB package"
fi

# Install DBeaver Community Edition from the downloaded file
if [ -f "$download_file" ]; then
    echo -e "${BLUE}Installing DBeaver Community Edition...${NC}"
    sudo dpkg -i "$download_file"
    handle_error $? "sudo dpkg install" "Failed to install DBeaver Community Edition"
    echo -e "${GREEN}DBeaver Community Edition installed successfully.${NC}"
    rm "$download_file" # Remove the downloaded file
else
    handle_error 1 "file check" "The downloaded DBeaver Community Edition DEB file does not exist"
fi

echo -e "${GREEN}DBeaver Community Edition installed successfully.${NC}"