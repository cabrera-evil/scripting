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
fi

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
# INSTALL K3S
# ================================
if command -v k3s >/dev/null 2>&1; then
	success "k3s is already installed at $(command -v k3s)."
	exit 0
fi

INSTALLER_SCRIPT="$(mktemp)"
trap 'rm -f "$INSTALLER_SCRIPT"' EXIT

log "Installing latest stable version of k3s..."
curl -sfL https://get.k3s.io -o "$INSTALLER_SCRIPT" || die "Failed to download k3s installer."
sh "$INSTALLER_SCRIPT" || die "Failed to install k3s."

# ================================
# DONE
# ================================
success "k3s installation completed successfully. Use 'sudo k3s kubectl get nodes' to verify."
