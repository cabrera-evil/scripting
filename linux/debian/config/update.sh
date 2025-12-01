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
# APT PACKAGE MAINTENANCE
# ================================
log "Updating APT package lists..."
sudo apt update -y

log "Upgrading installed packages..."
sudo apt upgrade -y --fix-missing 

log "Applying dist-upgrade..."
sudo apt dist-upgrade -y --fix-missing

log "Applying full-upgrade..."
sudo apt full-upgrade -y --fix-missing

log "Removing unused packages..."
sudo apt autoremove -y

log "Cleaning up cached packages..."
sudo apt autoclean -y

log "Fixing broken installations..."
sudo apt --fix-broken install -y

# ================================
# FLATPAK (OPTIONAL)
# ================================
if command -v flatpak >/dev/null; then
  log "Updating Flatpak packages..."
  sudo flatpak update --assumeyes
fi

# ================================
# SNAP (OPTIONAL)
# ================================
if command -v snap >/dev/null; then
  log "Refreshing Snap packages..."
  sudo snap refresh
fi

# ================================
# DONE
# ================================
success "System updates and package maintenance completed successfully!"
