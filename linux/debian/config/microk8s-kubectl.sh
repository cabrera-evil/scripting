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
for cmd in microk8s mkdir chmod tee; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
KUBECONFIG_DST="$HOME/.kube/config-microk8s"

# ===================================
# Wait for microk8s to be ready
# ===================================
log "Waiting for MicroK8s to become ready..."
microk8s status --wait-ready

# ===================================
# Create .kube directory
# ===================================
log "Creating ~/.kube directory..."
mkdir -p "$HOME/.kube"
chmod 700 "$HOME/.kube"

# ===================================
# Export kubeconfig
# ===================================
log "Exporting MicroK8s kubeconfig to $KUBECONFIG_DST..."
microk8s kubectl config view --raw | tee "$KUBECONFIG_DST" >/dev/null

success "MicroK8s kubeconfig exported successfully!"
