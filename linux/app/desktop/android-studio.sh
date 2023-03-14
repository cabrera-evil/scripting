#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install JDK 17
clear
echo -e "${BLUE}Downloading JDK 17...${NC}"
if ! wget -O /tmp/jdk-17_linux-x64_bin.deb "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb"; then
    echo -e "${RED}Failed to download JDK 17.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing JDK 17 dependencies...${NC}"
sudo apt-get install libc6-i386 libc6-x32 -y

echo -e "${BLUE}Installing JDK 17...${NC}"
if ! sudo dpkg -i /tmp/jdk-17_linux-x64_bin.deb; then
    echo -e "${RED}Failed to install JDK 17.${NC}"
    exit 1
fi

echo -e "${GREEN}JDK 17 installation complete!${NC}"

# Config JDK-17 PATH
echo -e "${BLUE}Configuring Java Path...${NC}"
export JAVA_HOME=/usr/lib/jvm/jdk-17
export PATH=$PATH:$JAVA_HOME/bin

echo -e "${green}Java Path configured successfully!${NC}"

# Install Android Studio IDE
sudo snap install android-studio --classic && echo -e "${GREEN}Android Studio installed.${NC}" || echo -e "${RED}Failed to install Android Studio.${NC}"