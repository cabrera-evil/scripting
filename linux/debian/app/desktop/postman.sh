#!/bin/bash
set -euo pipefail

# ===================================
# Colors for terminal output
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# Variables
# ===================================
URL="https://dl.pstmn.io/download/latest/linux64"
DEST_DIR="/opt/Postman"
TMP_TAR="/tmp/postman.tar.gz"

# ===================================
# Functions
# ===================================
log() {
	echo -e "${BLUE}$1${NC}"
}
success() {
	echo -e "${GREEN}$1${NC}"
}

# ===================================
# Download
# ===================================
log "Downloading Postman..."
wget -q --show-progress -O "$TMP_TAR" "$URL"

# ===================================
# Extract
# ===================================
log "Extracting Postman..."
tar -xf "$TMP_TAR" -C /tmp

# ===================================
# Remove existing Postman if it exists
# ===================================
if [ -d "$DEST_DIR" ]; then
	log "Removing existing Postman installation..."
	sudo rm -rf "$DEST_DIR"
fi

# ===================================
# Move to /opt
# ===================================
log "Moving Postman to /opt..."
sudo mv /tmp/Postman "$DEST_DIR"

# ===================================
# Create or update desktop entry
# ===================================
log "Creating Postman desktop entry..."
sudo tee /usr/share/applications/postman.desktop >/dev/null <<EOL
[Desktop Entry]
Name=Postman
GenericName=API Testing Tool
Comment=Simplify the process of developing APIs that allow you to connect to web services
Exec=${DEST_DIR}/Postman
Terminal=false
Type=Application
Icon=${DEST_DIR}/app/resources/app/assets/icon.png
Categories=Development;
EOL

# ===================================
# Create symbolic link
# ===================================
if [ -L /usr/bin/postman ] || [ -f /usr/bin/postman ]; then
	sudo rm -f /usr/bin/postman
fi
log "Creating Postman symbolic link..."
sudo ln -s "${DEST_DIR}/Postman" /usr/bin/postman

success "Postman installation or update complete!"
