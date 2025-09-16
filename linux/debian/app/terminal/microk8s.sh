#!/usr/bin/env bash
set -euo pipefail

# ===============================
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
fi

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
