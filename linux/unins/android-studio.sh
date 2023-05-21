#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
NC='\e[0m' # No Color

# Delete Android Studio
echo -e "${BLUE}Deleting Android Studio...${NC}"
if [ -d "/opt/android-studio" ]; then
    sudo rm -rf /opt/android-studio
    echo -e "${GREEN}Android Studio deleted.${NC}"
else
    echo -e "${BLUE}Android Studio not found.${NC}"
fi

# Delete Gradle cache
echo -e "${BLUE}Deleting Gradle cache...${NC}"
if [ -d "$HOME/.gradle" ]; then
    rm -rf "$HOME/.gradle"
    echo -e "${GREEN}Gradle cache deleted.${NC}"
else
    echo -e "${BLUE}Gradle cache not found.${NC}"
fi

# Delete Android Studio launcher
echo -e "${BLUE}Deleting Android Studio launcher...${NC}"
if [ -f "/usr/share/applications/android-studio.desktop" ]; then
    sudo rm "/usr/share/applications/android-studio.desktop"
    echo -e "${GREEN}Android Studio launcher deleted.${NC}"
else
    echo -e "${BLUE}Android Studio launcher not found.${NC}"
fi
