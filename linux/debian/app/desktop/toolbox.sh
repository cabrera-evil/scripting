#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# Logging
# ===================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
for cmd in wget curl jq tar sudo tee find; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect latest version
# ===================================
log "Detecting latest JetBrains Toolbox version..."
TOOLBOX_VERSION=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" |
    jq -r '.TBA[0].build') || abort "Failed to fetch Toolbox version"

TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
TMP_DIR="$(mktemp -d)"
TAR_FILE="${TMP_DIR}/toolbox.tar.gz"
INSTALL_DIR="/opt/jetbrains-toolbox"
BIN_PATH="/usr/local/bin/jetbrains-toolbox"
DESKTOP_ENTRY="/usr/share/applications/jetbrains-toolbox.desktop"

# ===================================
# Download
# ===================================
log "Downloading JetBrains Toolbox v${TOOLBOX_VERSION}..."
wget -q --show-progress -O "$TAR_FILE" "$TOOLBOX_URL"

# ===================================
# Extract
# ===================================
log "Extracting archive..."
tar -xzf "$TAR_FILE" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'jetbrains-toolbox-*' | head -n1)"

# ===================================
# Install
# ===================================
log "Installing to ${INSTALL_DIR}..."
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# ===================================
# Symlink
# ===================================
log "Creating symlink at /usr/local/bin..."
sudo ln -sf "${INSTALL_DIR}/jetbrains-toolbox" "$BIN_PATH"

# ===================================
# Desktop entry
# ===================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=JetBrains Toolbox
GenericName=JetBrains Toolbox
Comment=Manage JetBrains IDEs
Exec=${INSTALL_DIR}/jetbrains-toolbox
Icon=${INSTALL_DIR}/toolbox.svg
Terminal=false
Type=Application
Categories=Development;
EOF

success "JetBrains Toolbox v${TOOLBOX_VERSION} installed successfully. Run with 'jetbrains-toolbox'."
