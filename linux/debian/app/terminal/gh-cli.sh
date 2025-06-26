#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

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
for cmd in curl wget sudo tee apt dpkg; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
ARCH=$(dpkg --print-architecture)
KEYRING_DIR="/etc/apt/keyrings"
KEYRING_FILE="$KEYRING_DIR/githubcli-archive-keyring.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/github-cli.list"
REPO_URL="https://cli.github.com/packages"

# ===================================
# Setup
# ===================================
log "Creating keyring directory..."
sudo mkdir -p -m 755 "$KEYRING_DIR"

log "Downloading GitHub CLI keyring..."
wget -qO- "${REPO_URL}/githubcli-archive-keyring.gpg" | sudo tee "$KEYRING_FILE" >/dev/null

log "Setting permissions on keyring..."
sudo chmod go+r "$KEYRING_FILE"

log "Adding GitHub CLI APT repository..."
echo "deb [arch=${ARCH} signed-by=${KEYRING_FILE}] ${REPO_URL} stable main" | sudo tee "$SOURCE_LIST" >/dev/null

# ===================================
# Install
# ===================================
log "Updating APT package list..."
sudo apt update -y

log "Installing GitHub CLI (gh)..."
sudo apt install -y gh

success "GitHub CLI installation complete!"
