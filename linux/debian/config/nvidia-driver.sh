#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

set -e

echo -e "${BLUE}Starting NVIDIA Driver Setup for Debian Bookworm...${NC}"

# 1. Check for NVIDIA GPU
echo -e "${BLUE}Detecting NVIDIA GPU...${NC}"
if ! lspci | grep -i nvidia >/dev/null; then
    echo -e "${RED}No NVIDIA GPU found. Exiting.${NC}"
    exit 1
fi

# 2. Check if NVIDIA drivers are already installed
if command -v nvidia-smi >/dev/null 2>&1; then
    echo -e "${GREEN}NVIDIA drivers already appear to be installed.${NC}"
    echo -e "${BLUE}Recommended post-installation steps:${NC}"
    echo "  nvidia-smi"
    echo "  glxinfo | grep 'OpenGL renderer'"
    exit 0
fi

# 3. Blacklist Nouveau
echo -e "${BLUE}Blacklisting Nouveau driver...${NC}"
sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<EOF
blacklist nouveau
options nouveau modeset=0
EOF

echo -e "${BLUE}Updating initramfs...${NC}"
sudo update-initramfs -u

# 4. Add contrib and non-free repositories (optional)
# echo -e "${BLUE}Ensuring contrib and non-free repositories are enabled...${NC}"
# sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list

# 5. Update APT and install packages
echo -e "${BLUE}Updating package lists...${NC}"
sudo apt update

echo -e "${BLUE}Installing NVIDIA driver and firmware...${NC}"
sudo apt install -y nvidia-driver firmware-misc-nonfree mesa-utils

# 6. Final Notes
echo -e "${GREEN}NVIDIA driver installation complete.${NC}"
echo -e "${YELLOW}A reboot is required to activate the driver.${NC}"
echo -e "${BLUE}After reboot, verify the installation with:${NC}"
echo "  nvidia-smi"
echo "  glxinfo | grep 'OpenGL renderer'"

# 7. Optional reboot prompt
read -p $'\nDo you want to reboot now? [Y/n]: ' confirm
if [[ "$confirm" =~ ^[Yy]$ || -z "$confirm" ]]; then
    echo -e "${BLUE}Rebooting now...${NC}"
    sudo reboot
else
    echo -e "${YELLOW}Please reboot manually later to apply the changes.${NC}"
fi
