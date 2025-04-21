
#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define constants
TOOLBOX_VERSION="2.5.4.38621"
TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
TMP_DIR="/tmp/jetbrains-toolbox"
INSTALL_DIR="/opt/jetbrains-toolbox"

# Start
echo -e "${BLUE}Downloading JetBrains Toolbox ${TOOLBOX_VERSION}...${NC}"
mkdir -p "$TMP_DIR"
wget -q --show-progress -O "$TMP_DIR/toolbox.tar.gz" "$TOOLBOX_URL"

echo -e "${BLUE}Extracting Toolbox...${NC}"
tar -xzf "$TMP_DIR/toolbox.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "jetbrains-toolbox-*")

echo -e "${BLUE}Installing Toolbox to ${INSTALL_DIR}...${NC}"
sudo rm -rf "$INSTALL_DIR"
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

echo -e "${BLUE}Creating symbolic link in /usr/local/bin...${NC}"
sudo ln -sf "$INSTALL_DIR/jetbrains-toolbox" /usr/local/bin/jetbrains-toolbox

echo -e "${BLUE}Creating desktop entry...${NC}"
sudo tee /usr/share/applications/jetbrains-toolbox.desktop > /dev/null <<EOL
[Desktop Entry]
Name=JetBrains Toolbox
GenericName=JetBrains Toolbox
Comment=Manage JetBrains IDEs
Exec=${INSTALL_DIR}/jetbrains-toolbox
Icon=${INSTALL_DIR}/toolbox.svg
Terminal=false
Type=Application
Categories=Development;
EOL

echo -e "${GREEN}JetBrains Toolbox installation complete! You can run it with 'jetbrains-toolbox'.${NC}"

