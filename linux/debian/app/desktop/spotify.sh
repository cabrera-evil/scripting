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
for cmd in curl gpg sudo tee apt; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
SPOTIFY_KEY_URL="https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg"
SPOTIFY_KEY_PATH="/etc/apt/trusted.gpg.d/spotify.gpg"
SPOTIFY_LIST_PATH="/etc/apt/sources.list.d/spotify.list"
SPOTIFY_REPO="deb https://repository.spotify.com stable non-free"

# ===================================
# Add repository
# ===================================
log "Setting up the Spotify repository..."
curl -sS "$SPOTIFY_KEY_URL" | sudo gpg --dearmor --yes -o "$SPOTIFY_KEY_PATH"
echo "$SPOTIFY_REPO" | sudo tee "$SPOTIFY_LIST_PATH" >/dev/null

# ===================================
# Update packages
# ===================================
log "Updating package list..."
sudo apt update

# ===================================
# Install Spotify
# ===================================
log "Installing Spotify..."
sudo apt install -y spotify-client

success "Spotify installation complete!"
