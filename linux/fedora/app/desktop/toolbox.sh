#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

clear
# Install JDK 20
clear
if [ -d "/usr/lib/jvm/jdk-20" ]; then
    echo "JDK 20 already installed."
else
    echo -e "${BLUE}Downloading JDK 20...${NC}"
    if ! wget -O /tmp/jdk-20_linux-aarch64_bin.rpm "https://download.oracle.com/java/20/latest/jdk-20_linux-aarch64_bin.rpm"; then
        echo -e "${RED}Failed to download JDK 20.${NC}"
        exit 1
    fi

    echo -e "${BLUE}Installing JDK 20...${NC}"
    if ! sudo rpm -i /tmp/jdk-20_linux-aarch64_bin.rpm; then
        echo -e "${RED}Failed to install JDK 20.${NC}"
        exit 1
    fi

    echo -e "${GREEN}JDK 20 installation complete!${NC}"

    # Configure JDK-20 PATH
    echo -e "${BLUE}Configuring Java Path...${NC}"
    export JAVA_HOME=/usr/lib/jvm/jdk-20
    export PATH=$PATH:$JAVA_HOME/bin

    echo -e "${GREEN}Java Path configured successfully!${NC}"
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

# Create JetBrains Toolbox launcher
echo -e "${BLUE}Creating JetBrains Toolbox App launcher...${NC}"
if ! sudo ln -s /opt/jetbrains-toolbox-1.28.1.15219/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox; then
    echo -e "${RED}Failed to create JetBrains Toolbox App launcher.${NC}"
    exit 1
fi

echo -e "${GREEN}JetBrains Toolbox App installation complete!${NC}"
