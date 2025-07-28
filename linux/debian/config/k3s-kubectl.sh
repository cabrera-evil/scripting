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
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in sudo cat sed tee chown mkdir chmod; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
KUBECONFIG_SRC="/etc/rancher/k3s/k3s.yaml"
KUBECONFIG_DST="$HOME/.kube/config-local"

# ===================================
# CREATE .KUBE DIRECTORY
# ===================================
log "Creating ~/.kube directory with correct permissions..."
mkdir -p "$HOME/.kube"
chmod 700 "$HOME/.kube"

# ===================================
# EXPORT KUBECONFIG
# ===================================
log "Exporting K3s kubeconfig to $KUBECONFIG_DST..."
sudo cat "$KUBECONFIG_SRC" | tee "$KUBECONFIG_DST" >/dev/null

# ===================================
# UPDATE CONTEXT NAME TO 'LOCAL'
# ===================================
log "Replacing context name from 'default' to 'local'..."
sed -i 's/default/local/g' "$KUBECONFIG_DST"

# ===================================
# FIX PERMISSIONS
# ===================================
log "Setting correct ownership on kubeconfig..."
sudo chown "$(id -u):$(id -g)" "$KUBECONFIG_DST"

success "K3s kubeconfig exported and configured successfully!"
