#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
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
# Install Flatpak if missing
# ===================================
if ! command -v flatpak &>/dev/null; then
    log "Installing Flatpak..."
    sudo apt update
    sudo apt install -y flatpak

    log "Installing GNOME plugin for Flatpak..."
    sudo apt install -y gnome-software-plugin-flatpak

    log "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    log "Flatpak already installed."
fi

# ===================================
# Install Android Studio via Flatpak
# ===================================
APP_ID="com.google.AndroidStudio"
log "Installing Android Studio from Flathub..."
sudo flatpak install -y flathub "$APP_ID"

# ===================================
# Export Android SDK path (bashrc)
# ===================================
log "Configuring ANDROID_HOME in ~/.bashrc..."
if ! grep -q "ANDROID_HOME" ~/.bashrc; then
    tee -a ~/.bashrc >/dev/null <<'EOF'

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
EOF
else
    log "ANDROID_HOME already configured in ~/.bashrc"
fi

success "Android Studio installed and environment variables configured!"
