#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install Code
echo -e "${BLUE}Downloading Code...${NC}"
if ! wget -O /tmp/code.deb "https://az764295.vo.msecnd.net/stable/6445d93c81ebe42c4cbd7a60712e0b17d9463e97/code_1.81.0-1690980880_amd64.deb"; then
    echo -e "${RED}Failed to download Code.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing Code...${NC}"
if ! sudo apt install /tmp/code.deb; then
    echo -e "${RED}Failed to install Code.${NC}"
    exit 1
fi

echo -e "${GREEN}Code installation complete!${NC}"
