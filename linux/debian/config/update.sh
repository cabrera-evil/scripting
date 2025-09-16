#!/usr/bin/env bash
set -euo pipefail

# ================================
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

# ================================
# CHECKS
# ===================================
for cmd in sudo apt; do
  command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ================================
# APT PACKAGE MAINTENANCE
# ===================================
log "Updating APT package lists..."
sudo apt update -y

log "Upgrading installed packages..."
sudo apt upgrade -y

log "Applying dist-upgrade..."
sudo apt dist-upgrade -y

log "Applying full-upgrade..."
sudo apt full-upgrade -y

log "Removing unused packages..."
sudo apt autoremove -y

log "Cleaning up cached packages..."
sudo apt autoclean -y

log "Fixing broken installations..."
sudo apt --fix-broken install -y

# ================================
# FLATPAK (OPTIONAL)
# ===================================
if command -v flatpak >/dev/null; then
  log "Updating Flatpak packages..."
  sudo flatpak update --assumeyes
fi

# ================================
# SNAP (OPTIONAL)
# ===================================
if command -v snap >/dev/null; then
  log "Refreshing Snap packages..."
  sudo snap refresh
fi

# ================================
# DONE
# ===================================
success "System updates and package maintenance completed successfully!"
