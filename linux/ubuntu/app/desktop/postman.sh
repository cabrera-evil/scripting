#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://dl.pstmn.io/download/latest/linux64"

# Download Postman
echo -e "${BLUE}Downloading Postman...${NC}"
wget -O /tmp/postman.tar.gz "$URL"

# Extract Postman
echo -e "${BLUE}Extracting Postman...${NC}"
tar -xvf /tmp/postman.tar.gz -C /tmp

# Move Postman to /opt
echo -e "${BLUE}Moving Postman to /opt...${NC}"
sudo mv /tmp/Postman /opt

# Create Postman desktop entry
echo -e "${BLUE}Creating Postman desktop entry...${NC}"
sudo tee /usr/share/applications/postman.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Postman
GenericName=API Testing Tool
Comment=Simplify the process of developing APIs that allow you to connect to web services
Exec=/opt/Postman/Postman
Terminal=false
Type=Application
Icon=/opt/Postman/app/resources/app/assets/icon.png
Categories=Development;
EOL

# Create Postman symbolic link
echo -e "${BLUE}Creating Postman symbolic link...${NC}"
sudo ln -s /opt/Postman/Postman /usr/bin/postman

echo -e "${GREEN}Postman installation complete!${NC}"
