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
for cmd in microk8s; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
PLUGINS=(
    dns
    dashboard
    cert-manager
    hostpath-storage
    ingress
)

# ===================================
# Wait for microk8s to be ready
# ===================================
log "Waiting for MicroK8s to become ready..."
microk8s status --wait-ready

# ===================================
# Enable Plugins
# ===================================
log "Enabling MicroK8s plugins..."
for plugin in "${PLUGINS[@]}"; do
    log "Enabling $plugin..."
    if microk8s enable "$plugin"; then
        success "$plugin enabled"
    else
        abort "Failed to enable $plugin"
    fi
done

success "All MicroK8s plugins enabled successfully!"
