#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define version and URL
VERSION="3.16.4"
URL="https://github.com/nextcloud-releases/desktop/releases/download/v$VERSION/Nextcloud-$VERSION-x86_64.AppImage"

# Download Nextcloud AppImage
echo -e "${BLUE}Downloading Nextcloud...${NC}"
wget -O /tmp/Nextcloud.AppImage "$URL"

# Install Nextcloud
echo -e "${BLUE}Installing Nextcloud...${NC}"
mkdir -p ~/.local/bin
mv /tmp/Nextcloud.AppImage ~/.local/bin/Nextcloud.AppImage
chmod +x ~/.local/bin/Nextcloud.AppImage

# Create desktop entry
mkdir -p ~/.local/share/applications
cat >~/.local/share/applications/nextcloud.desktop <<EOF
[Desktop Entry]
Name=Nextcloud
Exec=$HOME/.local/bin/Nextcloud.AppImage
Icon=nextcloud
Type=Application
Categories=Network;
Comment=Nextcloud Desktop Client
Terminal=false
EOF

echo -e "${GREEN}Nextcloud installation complete!${NC}"
