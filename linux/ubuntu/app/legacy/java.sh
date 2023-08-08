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

# Download JDK 17
echo -e "${BLUE}Downloading JDK 17...${NC}"
wget -O /tmp/jdk-17_linux-x64_bin.deb "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb"
handle_error $? "wget" "Failed to download JDK 17"

# Install JDK 17
echo -e "${BLUE}Installing JDK 17 dependencies...${NC}"
sudo apt install libc6-i386 libc6-x32 -y
handle_error $? "apt install libc6-i386 libc6-x32" "Failed to install JDK 17 dependencies"

echo -e "${BLUE}Installing JDK 17...${NC}"
sudo apt install /tmp/jdk-17_linux-x64_bin.deb
handle_error $? "apt install /tmp/jdk-17_linux-x64_bin.deb" "Failed to install JDK 17"

echo -e "${GREEN}JDK 17 installation complete!${NC}"

# Config JDK-17 PATH
echo -e "${BLUE}Configuring Java Path...${NC}"
export JAVA_HOME=/usr/lib/jvm/jdk-17
handle_error $? "export JAVA_HOME=/usr/lib/jvm/jdk-17" "Failed to configure Java Path"
export PATH=$PATH:$JAVA_HOME/bin
handle_error $? "export PATH=$PATH:$JAVA_HOME/bin" "Failed to configure Java Path"

echo -e "${green}Java Path configured successfully!${NC}"
