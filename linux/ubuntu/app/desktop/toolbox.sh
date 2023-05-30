#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install JDK 17
if [ -d "/usr/lib/jvm/jdk-17" ]; then
    echo "JDK 17 already installed."
else
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
fi

# Install Jetbrains Toolbox
echo -e "${BLUE}Downloading JetBrains Toolbox App...${NC}"
if ! wget -O /tmp/toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz?_gl=1*1a41i3s*_ga*MTQ0MTQ4MDkwMy4xNjg0NDcwMDA1*_ga_9J976DJZ68*MTY4NDQ3MDAwNS4xLjEuMTY4NDQ3MDEyMi4wLjAuMA.."; then
    echo -e "${RED}Failed to download JetBrains Toolbox App.${NC}"
    exit 1
fi

echo -e "${BLUE}Extracting JetBrains Toolbox App...${NC}"
if ! sudo tar -xzf /tmp/toolbox.tar.gz -C /opt/; then
    echo -e "${RED}Failed to extract JetBrains Toolbox App.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing JetBrains Toolbox App...${NC}"
if ! sudo /opt/jetbrains-toolbox-1.28.1.15219/jetbrains-toolbox; then
    echo -e "${RED}Failed to install JetBrains Toolbox App.${NC}"
    exit 1
fi

# Create Jetbrains Toolbox launcher
echo -e "${BLUE}Creating JetBrains Toolbox App launcher...${NC}"
if ! sudo ln -s /opt/jetbrains-toolbox-1.28.1.15219/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox; then
    echo -e "${RED}Failed to create JetBrains Toolbox App launcher.${NC}"
    exit 1
fi

echo -e "${GREEN}JetBrains Toolbox App installation complete!${NC}"
