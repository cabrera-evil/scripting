#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

echo -e "${BLUE}Deleting JetBrains Toolbox App...${NC}"
if ! sudo rm -rf /opt/jetbrains-toolbox; then
    echo -e "${RED}Failed to install JetBrains Toolbox App.${NC}"
    exit 1
fi

# Create Jetbrains Toolbox launcher
echo -e "${BLUE}Deleting JetBrains Toolbox App launcher...${NC}"
if ! sudo rm -rf /usr/local/bin/jetbrains-toolbox; then
    echo -e "${RED}Failed to create JetBrains Toolbox App launcher.${NC}"
    exit 1
fi

echo -e "${GREEN}JetBrains Toolbox App uninstall complete!${NC}"
