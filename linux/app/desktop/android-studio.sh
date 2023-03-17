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

Install Android Studio
echo -e "${BLUE}Downloading Android Studio...${NC}"
if ! wget -O /tmp/android-studio-2022.1.1.21-linux.tar.gz "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.21/android-studio-2022.1.1.21-linux.tar.gz"; then
    echo -e "${RED}Failed to download Android Studio.${NC}"
    exit 1
fi

echo -e "${BLUE}Extracting Android Studio...${NC}"
if ! sudo tar -xvzf /tmp/android-studio-2022.1.1.21-linux.tar.gz -C /opt/; then
    echo -e "${RED}Failed to extract Android Studio.${NC}"
    exit 1
fi

echo -e "${BLUE}Creating desktop entry for Android Studio...${NC}"
cat <<EOF | sudo tee /usr/share/applications/android-studio.desktop > /dev/null
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/opt/android-studio/bin/studio.sh
Name=Android Studio
Icon=/opt/android-studio/bin/studio.png
EOF

sudo chmod +x /usr/share/applications/android-studio.desktop

echo -e "${GREEN}Android Studio has been installed.${NC}"