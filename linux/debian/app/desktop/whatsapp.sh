#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != true ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != true ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != true ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != true ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in sudo apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# INSTALL FLATPAK IF NOT PRESENT
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
# INSTALL WHATSAPP DESKTOP
# ===================================
APP_ID="com.rtosta.zapzap"
log "Installing WhatsApp Desktop from Flathub..."
sudo flatpak install -y flathub "$APP_ID"

success "WhatsApp Desktop installed successfully via Flatpak!"
