#!/usr/bin/env bash
set -euo pipefail

# ================================
# Colors
# ================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ================================
# Logging
# ================================
log()     { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort()   { echo -e "${RED}✗ $1${NC}" >&2; exit 1; }

# ================================
# Checks
# ================================
for cmd in sudo apt; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# APT Package Maintenance
# ================================
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
# Flatpak (optional)
# ================================
if command -v flatpak >/dev/null; then
  log "Updating Flatpak packages..."
  sudo flatpak update --assumeyes
fi

# ================================
# Snap (optional)
# ================================
if command -v snap >/dev/null; then
  log "Refreshing Snap packages..."
  sudo snap refresh
fi

# ================================
# Done
# ================================
success "System updates and package maintenance completed successfully!"
