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
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ================================
# Check required commands
# ================================
for cmd in sudo usermod groups grep; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# Add user to sudo group
# ================================
log "Adding current user ($USER) to sudo group..."
sudo usermod -aG sudo "$USER"

log "Verifying sudo group membership..."
if groups "$USER" | grep -qw "sudo"; then
    success "User '$USER' is now in the sudo group."
else
    abort "Failed to add user '$USER' to sudo group."
fi
