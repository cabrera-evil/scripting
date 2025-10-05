#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	RED=$'\033[0;31m'
	GREEN=$'\033[0;32m'
	YELLOW=$'\033[0;33m'
	BLUE=$'\033[0;34m'
	MAGENTA=$'\033[0;35m'
	BOLD=$'\033[1m'
	DIM=$'\033[2m'
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false

# ================================
# LOGGING FUNCTIONS
# ================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
die() {
	error "$*"
	exit 1
}

# ================================
# CONFIG
# ================================
KUBECONFIG_SRC="/etc/rancher/k3s/k3s.yaml"
KUBECONFIG_DST="$HOME/.kube/config-local"

# ================================
# CREATE .KUBE DIRECTORY
# ================================
log "Creating ~/.kube directory with correct permissions..."
mkdir -p "$HOME/.kube"
chmod 700 "$HOME/.kube"

# ================================
# EXPORT KUBECONFIG
# ================================
log "Exporting K3s kubeconfig to $KUBECONFIG_DST..."
sudo cat "$KUBECONFIG_SRC" | tee "$KUBECONFIG_DST" >/dev/null

# ================================
# UPDATE CONTEXT NAME TO 'LOCAL'
# ================================
log "Replacing context name from 'default' to 'local'..."
sed -i 's/default/local/g' "$KUBECONFIG_DST"

# ================================
# FIX PERMISSIONS
# ================================
log "Setting correct ownership on kubeconfig..."
sudo chown "$(id -u):$(id -g)" "$KUBECONFIG_DST"

success "K3s kubeconfig exported and configured successfully!"
