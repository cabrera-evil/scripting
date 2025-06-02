#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL=https://downloads.realvnc.com/download/file/realvnc-connect/RealVNC-Connect-8.0.0-Linux-x64.deb?lai_vid=K9z1LO2XPI9n&lai_sr=5-9&lai_sl=l&lai_p=1

# Download VNC Connect
echo -e "${BLUE}Downloading VNC Connect...${NC}"
wget -O /tmp/vnc-connect.deb "$URL"

# Install VNC Connect
echo -e "${BLUE}Installing VNC Connect...${NC}"
sudo apt install -y /tmp/vnc-connect.deb

echo -e "${GREEN}VNC Connect installation complete!${NC}"