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

# Download AWS CLI installer
echo -e "${BLUE}Downloading AWS CLI installer...${NC}"
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /tmp/awscliv2.zip
handle_error $? "AWS CLI installer download" "Failed to download AWS CLI installer."

# Unzip the installer
echo -e "${BLUE}Unzipping AWS CLI installer...${NC}"
unzip -q /tmp/awscliv2.zip -d /tmp/
handle_error $? "AWS CLI installer unzip" "Failed to unzip AWS CLI installer."

# Install AWS CLI
echo -e "${BLUE}Installing AWS CLI...${NC}"
sudo /tmp/aws/install --update
handle_error $? "AWS CLI installation" "Failed to install AWS CLI."