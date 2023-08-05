#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download and install VirtualBox
echo -e "${BLUE}Downloading VirtualBox...${NC}"
if ! wget -O /tmp/virtualbox.deb "https://download.virtualbox.org/virtualbox/7.0.8/virtualbox-7.0_7.0.8-156879~Ubuntu~jammy_amd64.deb"; then
    echo -e "${RED}Failed to download VirtualBox.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing VirtualBox...${NC}"
if ! sudo apt install /tmp/virtualbox.deb; then
    echo -e "${RED}VirtualBox installed with some errors.${NC}"
fi

# Sign VirtualBox kernel modules
if [ -d "/sys/firmware/efi" ]; then
    echo -e "${BLUE}Signing VirtualBox kernel modules...${NC}"
    sudo /sbin/vboxconfig
fi

echo -e "${GREEN}VirtualBox installation complete!${NC}"

# Check if UEFI Secure Boot is enabled
if [[ $(mokutil --sb-state) == "SecureBoot enabled" ]]; then
    echo -e "${BLUE}Secure Boot is enabled. Signing VirtualBox kernel modules...${NC}"

    # Installing required packages
    sudo apt-get install dkms build-essential linux-headers-$(uname -r)
    
    # Generate a new key-pair for VirtualBox
    sudo openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox/"

    # Import the MOK (Machine Owner Key) into the firmware
    sudo mokutil --import MOK.der

    # Sign the VirtualBox kernel modules with the new key-pair
    sudo /sbin/vboxconfig

    echo -e "${GREEN}VirtualBox kernel modules signed successfully!${NC}"
fi
