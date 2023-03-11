#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Install Proton dependencies
clear
echo -e "${YELLOW}Installing Proton dependencies...${NC}"
sudo apt-get install -y libgbm-dev

# Print success message
echo -e "${GREEN}Proton dependencies and development tools installed successfully.${NC}"

# Install basic development tools
clear
echo -e "${YELLOW}Installing Basic Development Tools...${NC}"
sudo apt-get install build-essential -y

# Install JDK 17
clear
echo -e "${blue}Downloading JDK 17...${NC}"
if ! wget -O /tmp/jdk-17_linux-x64_bin.deb "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb"; then
    echo -e "${red}Failed to download JDK 17.${NC}"
    exit 1
fi

echo -e "${blue}Installing JDK 17 dependencies...${NC}"
sudo apt-get install libc6-i386 libc6-x32 -y

echo -e "${blue}Installing JDK 17...${NC}"
if ! sudo dpkg -i /tmp/jdk-17_linux-x64_bin.deb; then
    echo -e "${red}Failed to install JDK 17.${NC}"
    exit 1
fi

echo -e "${green}JDK 17 installation complete!${NC}"

# Config JDK-17 PATH
echo -e "${blue}Configuring Java Path...${NC}"
export JAVA_HOME=/usr/lib/jvm/jdk-17
export PATH=$PATH:$JAVA_HOME/bin

echo -e "${green}Java Path configured successfully!${NC}"
