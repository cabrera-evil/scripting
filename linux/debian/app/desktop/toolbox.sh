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

# Install Jetbrains Toolbox
echo -e "${BLUE}Downloading JetBrains Toolbox App...${NC}"
wget -O /tmp/toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz?_gl=1*1a41i3s*_ga*MTQ0MTQ4MDkwMy4xNjg0NDcwMDA1*_ga_9J976DJZ68*MTY4NDQ3MDAwNS4xLjEuMTY4NDQ3MDEyMi4wLjAuMA.."
handle_error $? "Downloading JetBrains Toolbox App." "JetBrains Toolbox App downloaded." "Failed to download JetBrains Toolbox App."

echo -e "${BLUE}Extracting JetBrains Toolbox App...${NC}"
sudo tar -xzf /tmp/toolbox.tar.gz -C /opt/
handle_error $? "Extracting JetBrains Toolbox App." "JetBrains Toolbox App extracted." "Failed to extract JetBrains Toolbox App."

echo -e "${BLUE}Installing JetBrains Toolbox App...${NC}"
sudo /opt/jetbrains-toolbox-1.28.1.15219/jetbrains-toolbox
handle_error $? "JetBrains Toolbox App installation complete!" "Failed to install JetBrains Toolbox App."

# Create Jetbrains Toolbox launcher
echo -e "${BLUE}Creating JetBrains Toolbox App launcher...${NC}"
sudo ln -s /opt/jetbrains-toolbox-1.28.1.15219/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox
handle_error $? "JetBrains Toolbox App launcher created." "Failed to create JetBrains Toolbox App launcher."

echo -e "${GREEN}JetBrains Toolbox App installation complete!${NC}"
