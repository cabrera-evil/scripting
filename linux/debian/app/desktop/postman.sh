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
        echo -e "${RED}Error: $command failed - $message${NC}"
        exit $exit_code
    fi
}

# Download Postman
echo -e "${YELLOW}Downloading Postman...${NC}"
wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/postman.tar.gz

# Extract Postman
echo -e "${YELLOW}Extracting Postman...${NC}"
tar -xvf /tmp/postman.tar.gz -C /tmp

# Move Postman to /opt
echo -e "${YELLOW}Moving Postman to /opt...${NC}"
sudo mv /tmp/Postman /opt

# Create Postman desktop entry
echo -e "${YELLOW}Creating Postman desktop entry...${NC}"
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
echo -e "${YELLOW}Creating Postman symbolic link...${NC}"
sudo ln -s /opt/Postman/Postman /usr/bin/postman

echo -e "${GREEN}Postman installation complete!${NC}"
