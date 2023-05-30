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

# Install Spotify
echo -e "${BLUE}Installing Spotify...${NC}"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y
handle_error $? "Installing Spotify" "Spotify installed." "Failed to install Spotify."
