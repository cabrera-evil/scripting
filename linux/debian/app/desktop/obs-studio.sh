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
for cmd in sudo apt tee; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Flatpak setup
# ===================================
if ! command -v flatpak &>/dev/null; then
    log "Installing Flatpak..."
    sudo apt update
    sudo apt install -y flatpak

    log "Installing GNOME Flatpak plugin..."
    sudo apt install -y gnome-software-plugin-flatpak

    log "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    log "Flatpak already installed."
fi

# ===================================
# Install OBS Studio
# ===================================
APP_ID="com.obsproject.Studio"
log "Installing OBS Studio from Flathub..."
sudo flatpak install -y flathub "$APP_ID"

success "OBS Studio installed successfully via Flatpak!"
