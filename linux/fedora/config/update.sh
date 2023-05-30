#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Updating system
clear
echo -e "${BLUE}Updating System${NC}"
if sudo dnf update -y; then
    echo -e "${GREEN}System update complete.${NC}"
else
    echo -e "${RED}Failed to update system.${NC}"
    exit 1
fi

# Upgrading packages
echo -e "${BLUE}Upgrading Packages${NC}"
if sudo dnf upgrade -y; then
    echo -e "${GREEN}Package upgrade complete.${NC}"
else
    echo -e "${RED}Failed to upgrade packages.${NC}"
    exit 1
fi

# Update flatpak packages
echo -e "${BLUE}Updating Flatpak Packages${NC}"
if flatpak update -y; then
    echo -e "${GREEN}Flatpak packages updated.${NC}"
else
    echo -e "${RED}Failed to update flatpak packages.${NC}"
    exit 1
fi

# Clean package cache
echo -e "${BLUE}Cleaning Package Cache${NC}"
if sudo dnf clean all; then
    echo -e "${GREEN}Package cache cleaned.${NC}"
else
    echo -e "${RED}Failed to clean package cache.${NC}"
    exit 1
fi

# Fixing broken dependencies
echo -e "${BLUE}Fixing Broken Dependencies${NC}"
if sudo dnf check -y; then
    echo -e "${GREEN}Broken dependencies fixed.${NC}"
else
    echo -e "${RED}Failed to fix broken dependencies.${NC}"
    exit 1
fi

# Remove unused packages
echo -e "${BLUE}Removing Unused Packages${NC}"
if sudo dnf autoremove -y; then
    echo -e "${GREEN}Unused packages removed.${NC}"
else
    echo -e "${RED}Failed to remove unused packages.${NC}"
    exit 1
fi

echo -e "${GREEN}System maintenance complete.${NC}"
