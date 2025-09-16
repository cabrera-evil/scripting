#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	readonly RED=$'\033[0;31m'
	readonly GREEN=$'\033[0;32m'
	readonly YELLOW=$'\033[0;33m'
	readonly BLUE=$'\033[0;34m'
	readonly MAGENTA=$'\033[0;35m'
	readonly BOLD=$'\033[1m'
	readonly DIM=$'\033[2m'
	readonly NC=$'\033[0m'
else
	readonly RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
QUIET=false
DEBUG=false

# ===================================
# LOGGING FUNCTIONS
# ===================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
die() {
	error "$*"
	exit 1
}

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
