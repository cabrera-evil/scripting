#!/usr/bin/env bash
set -euo pipefail

# ===============================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

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

# ===============================
# INSTALL SNAPD
# ===================================
log "Installing snapd..."
sudo apt update -y
sudo apt install snapd -y

# ===============================
# INSTALL MICROK8S
# ===================================
log "Installing microk8s via snap..."
sudo snap install microk8s --classic

# ===============================
# ADD USER TO MICROK8S GROUP
# ===================================
log "Adding current user to microk8s group..."
sudo usermod -aG microk8s "$USER"

success "MicroK8s installation complete. You may need to log out and back in to apply group changes."
