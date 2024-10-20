#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz"

# Download Toolbox
echo -e "${BLUE}Downloading Toolbox...${NC}"
wget -O /tmp/toolbox.tar.gz "$URL"

# Extract Toolbox
echo -e "${BLUE}Installing Toolbox...${NC}"
tar -xzf /tmp/toolbox.tar.gz -C /tmp

# Move Toolbox to /opt
echo -e "${BLUE}Moving Toolbox to /opt...${NC}"
sudo mv /tmp/jetbrains-toolbox-* /opt/jetbrains-toolbox

# Create Toolbox desktop entry
echo -e "${BLUE}Creating Toolbox desktop entry...${NC}"
# sudo tee /usr/share/applications/toolbox.desktop > /dev/null <<EOL
# [Desktop Entry]
# Name=Toolbox
# GenericName=JetBrains Toolbox
# Comment=Manage JetBrains tools
# Exec=/opt/jetbrains-toolbox/jetbrains-toolbox
# Terminal=false
# Type=Application
# Icon=/opt/jetbrains-toolbox/toolbox.svg
# Categories=Development;
# EOL

# Create symbolic link
echo -e "${BLUE}Creating symbolic link...${NC}"
# sudo ln -s /opt/jetbrains-toolbox/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox

echo -e "${GREEN}Toolbox installation complete!${NC}"
