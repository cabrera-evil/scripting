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
for cmd in curl jq wget sudo dpkg apt; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect version and architecture
# ===================================
log "Fetching latest Obsidian version..."
API_URL="https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"
VERSION=$(curl -s "$API_URL" | jq -r .tag_name | sed 's/^v//') || abort "Unable to retrieve version."
ARCH="$(dpkg --print-architecture)"
FILENAME="obsidian_${VERSION}_${ARCH}.deb"
DOWNLOAD_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

log "Detected version: v$VERSION"
log "Architecture: $ARCH"
log "Downloading: $FILENAME"

# ===================================
# Download
# ===================================
wget -O "$TMP_DEB" "$DOWNLOAD_URL"

# ===================================
# Install
# ===================================
log "Installing Obsidian..."
sudo apt install -y "$TMP_DEB"

success "Obsidian v${VERSION} installed successfully!"
