#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# If Flatpak is not installed, install it
if ! [ -x "$(command -v flatpak)" ]; then
    # Installing flatpak
    echo -e "${BLUE}Installing flatpak${NC}"
    sudo apt install flatpak -y
    handle_error $? "sudo apt install flatpak" "flatpak installed successfully" "Error installing flatpak"

    # Install flatpak plugin for gnome software
    echo -e "${BLUE}Installing flatpak plugin for gnome software${NC}"
    sudo apt install gnome-software-plugin-flatpak -y
    handle_error $? "sudo apt install gnome-software-plugin-flatpak" "flatpak plugin for gnome software installed successfully" "Error installing flatpak plugin for gnome software"

    # Add flathub repository
    echo -e "${BLUE}Adding flathub repository${NC}"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    handle_error $? "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" "Flathub repository added successfully" "Error adding flathub repository"
fi

# Install Google Android Studio via Flatpak
echo -e "${BLUE}Installing Google Android Studio...${NC}"
flatpak install flathub com.google.AndroidStudio -y
handle_error $? "flatpak install" "Failed to install Google Android Studio."

# Export Android Sdk path
echo -e "${BLUE}Exporting Android Sdk path...${NC}"
cat <<'EOF' | tee -a ~/.bashrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF

echo -e "${GREEN}Google Android Studio installation complete!${NC}"
