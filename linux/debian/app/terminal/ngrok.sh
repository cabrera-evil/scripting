#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"

# Download ngrok
echo -e "${BLUE}Downloading ngrok...${NC}"
wget -O /tmp/ngrok.zip "$URL"

# Unzip ngrok
echo -e "${BLUE}Unzipping ngrok...${NC}"
unzip /tmp/ngrok.zip -d /tmp

# Move ngrok to /usr/local/bin
echo -e "${BLUE}Moving ngrok to /usr/local/bin...${NC}"
sudo mv /tmp/ngrok /usr/local/bin/ngrok

# Make ngrok executable
echo -e "${BLUE}Making ngrok executable...${NC}"
sudo chmod +x /usr/local/bin/ngrok

echo -e "${GREEN}Ngrok installation complete!${NC}"