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

# Download ngrok
echo -e "${BLUE}Downloading ngrok...${NC}"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /tmp/ngrok.zip
handle_error $? "wget ngrok" "Failed to download ngrok"

# Unzip ngrok
echo -e "${BLUE}Unzipping ngrok...${NC}"
unzip /tmp/ngrok.zip -d /tmp
handle_error $? "unzip ngrok" "Failed to unzip ngrok"

# Move ngrok to /usr/local/bin
echo -e "${BLUE}Moving ngrok to /usr/local/bin...${NC}"
sudo mv /tmp/ngrok /usr/local/bin/ngrok
handle_error $? "mv ngrok" "Failed to move ngrok"

# Make ngrok executable
echo -e "${BLUE}Making ngrok executable...${NC}"
sudo chmod +x /usr/local/bin/ngrok
handle_error $? "chmod ngrok" "Failed to make ngrok executable"

echo -e "${GREEN}ngrok installation complete!${NC}"