#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

echo -e "${BLUE}Adding Ngrok GPG key...${NC}"
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc |
    sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null

echo -e "${BLUE}Adding Ngrok APT source...${NC}"
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" |
    sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null

echo -e "${BLUE}Updating package lists...${NC}"
sudo apt update

echo -e "${BLUE}Installing Ngrok...${NC}"
sudo apt install -y ngrok

echo -e "${GREEN}Ngrok installation complete!${NC}"
