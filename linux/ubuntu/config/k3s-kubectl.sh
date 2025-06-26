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
for cmd in sudo cat sed tee chown mkdir chmod; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
KUBECONFIG_SRC="/etc/rancher/k3s/k3s.yaml"
KUBECONFIG_DST="$HOME/.kube/config-local"

# ===================================
# Create .kube directory
# ===================================
log "Creating ~/.kube directory with correct permissions..."
mkdir -p "$HOME/.kube"
chmod 700 "$HOME/.kube"

# ===================================
# Export kubeconfig
# ===================================
log "Exporting K3s kubeconfig to $KUBECONFIG_DST..."
sudo cat "$KUBECONFIG_SRC" | tee "$KUBECONFIG_DST" >/dev/null

# ===================================
# Update context name to 'local'
# ===================================
log "Replacing context name from 'default' to 'local'..."
sed -i 's/default/local/g' "$KUBECONFIG_DST"

# ===================================
# Fix permissions
# ===================================
log "Setting correct ownership on kubeconfig..."
sudo chown "$(id -u):$(id -g)" "$KUBECONFIG_DST"

success "K3s kubeconfig exported and configured successfully!"
