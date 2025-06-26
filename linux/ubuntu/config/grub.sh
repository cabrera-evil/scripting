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
warn() { echo -e "${YELLOW}! $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
for cmd in sudo cp sed grep update-grub; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

GRUB_FILE="/etc/default/grub"
GRUB_BACKUP="/etc/default/grub.bak"

# ===================================
# Backup original GRUB config
# ===================================
log "Backing up GRUB configuration to $GRUB_BACKUP..."
sudo cp "$GRUB_FILE" "$GRUB_BACKUP"

# ===================================
# Set GRUB_DEFAULT=saved
# ===================================
log "Setting GRUB_DEFAULT to 'saved'..."
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE"

# ===================================
# Ensure GRUB_SAVEDEFAULT=true is present
# ===================================
if grep -q '^GRUB_SAVEDEFAULT=true' "$GRUB_FILE"; then
    warn "GRUB_SAVEDEFAULT already present. Skipping..."
else
    log "Adding GRUB_SAVEDEFAULT=true..."
    sudo sed -i '/^GRUB_DEFAULT=.*/a GRUB_SAVEDEFAULT=true' "$GRUB_FILE"
fi

# ===================================
# Set GRUB_TIMEOUT=5
# ===================================
log "Setting GRUB_TIMEOUT to 5 seconds..."
if grep -q '^GRUB_TIMEOUT=' "$GRUB_FILE"; then
    sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' "$GRUB_FILE"
else
    echo 'GRUB_TIMEOUT=5' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# Ensure GRUB_DISABLE_OS_PROBER=false
# ===================================
log "Ensuring GRUB_DISABLE_OS_PROBER=false..."
if grep -q '^#*GRUB_DISABLE_OS_PROBER=' "$GRUB_FILE"; then
    sudo sed -i 's/^#*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE"
else
    echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# Apply GRUB configuration
# ===================================
log "Updating GRUB..."
sudo update-grub

success "GRUB configuration updated successfully!"
