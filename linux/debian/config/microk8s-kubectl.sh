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
for cmd in microk8s mkdir chmod tee; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
KUBECONFIG_DST="$HOME/.kube/config-microk8s"

# ===================================
# WAIT FOR MICROK8S TO BE READY
# ===================================
log "Waiting for MicroK8s to become ready..."
microk8s status --wait-ready

# ===================================
# CREATE .KUBE DIRECTORY
# ===================================
log "Creating ~/.kube directory..."
mkdir -p "$HOME/.kube"
chmod 700 "$HOME/.kube"

# ===================================
# EXPORT KUBECONFIG
# ===================================
log "Exporting MicroK8s kubeconfig to $KUBECONFIG_DST..."
microk8s kubectl config view --raw | tee "$KUBECONFIG_DST" >/dev/null

success "MicroK8s kubeconfig exported successfully!"
