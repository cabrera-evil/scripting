#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Set up the Spotify repository
echo -e "${BLUE}Setting up the Spotify repository...${NC}"
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# Update the package list
echo -e "${BLUE}Updating the package list...${NC}"
sudo apt update

# Install Spotify
echo -e "${BLUE}Installing Spotify...${NC}"
sudo apt install -y spotify-client

echo -e "${GREEN}Spotify installation complete!${NC}"
