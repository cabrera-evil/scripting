#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# If Flatpak is not installed, install it
if ! [ -x "$(command -v flatpak)" ]; then
    # Installing flatpak
    echo -e "${BLUE}Installing flatpak${NC}"
    sudo apt install flatpak -y

    # Install flatpak plugin for gnome software
    echo -e "${BLUE}Installing flatpak plugin for gnome software${NC}"
    sudo apt install gnome-software-plugin-flatpak -y

    # Add flathub repository
    echo -e "${BLUE}Adding flathub repository${NC}"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Google Android Studio via Flatpak
echo -e "${BLUE}Installing Google Android Studio...${NC}"
flatpak install flathub com.google.AndroidStudio -y

# Export Android Sdk path
echo -e "${BLUE}Exporting Android Sdk path...${NC}"
if ! grep -q "ANDROID_HOME" ~/.bashrc; then
    cat <<'EOF' | tee -a ~/.bashrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF
fi

echo -e "${GREEN}Google Android Studio installation complete!${NC}"
