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
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Download and install Visual Studio Code
echo -e "${BLUE}Downloading Visual Studio Code...${NC}"
wget -O /tmp/vscode.rpm https://az764295.vo.msecnd.net/stable/660393deaaa6d1996740ff4880f1bad43768c814/code-1.80.0-1688479104.el7.x86_64.rpm

echo -e "${BLUE}Installing Visual Studio Code...${NC}"
sudo dnf install -y /tmp/vscode.rpm
handle_error $? "dnf install" "See /var/log/dnf.log for details"