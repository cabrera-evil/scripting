#!/usr/bin/env bash
set -euo pipefail

# ===============================
# Colors
# ===============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===============================
# Logging functions
# ===============================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===============================
# Install snapd
# ===============================
log "Installing snapd..."
sudo apt update -y
sudo apt install snapd -y

# ===============================
# Install microk8s
# ===============================
log "Installing microk8s via snap..."
sudo snap install microk8s --classic

# ===============================
# Add user to microk8s group
# ===============================
log "Adding current user to microk8s group..."
sudo usermod -aG microk8s "$USER"

success "MicroK8s installation complete. You may need to log out and back in to apply group changes."
