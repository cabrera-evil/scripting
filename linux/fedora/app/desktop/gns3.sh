#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install GNS3 dependencies
echo -e "${BLUE}Installing GNS3 dependencies...${NC}"
sudo dnf install -y cmake elfutils-libelf-devel libpcap-devel python3-devel qt5-qtbase-devel libvirt libvirt-devel dynamips git python3-netifaces vpcs
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install GNS3 dependencies.${NC}"
    exit 1
fi

# Install Wireshark (optional)
echo -e "${BLUE}Installing Wireshark...${NC}"
sudo dnf install -y wireshark
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install Wireshark.${NC}"
fi

# Clone GNS3 repository
echo -e "${BLUE}Cloning GNS3 repository...${NC}"
git clone https://github.com/GNS3/gns3-gui.git
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to clone GNS3 repository.${NC}"
    exit 1
fi

# Build and install GNS3
echo -e "${BLUE}Building and installing GNS3...${NC}"
cd gns3-gui
mkdir build
cd build
cmake ..
make
sudo make install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build and install GNS3.${NC}"
    exit 1
fi

echo -e "${GREEN}GNS3 installation complete!${NC}"
