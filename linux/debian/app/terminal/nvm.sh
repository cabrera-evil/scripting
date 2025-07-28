#!/usr/bin/env bash
set -euo pipefail

# ===============================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}
# ===============================
# CHECKS
# ===================================
for cmd in curl wget bash sudo; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===============================
# GET LATEST NVM VERSION
# ===================================
log "Fetching latest NVM version..."
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest |
	grep tag_name | sed -E 's/.*"v([^"]+)".*/v\1/')
[ -z "$NVM_VERSION" ] && abort "Unable to determine latest NVM version."

# ===============================
# INSTALL NVM
# ===================================
log "Installing NVM ${NVM_VERSION}..."
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# ===============================
# SOURCE NVM IN CURRENT SESSION
# ===================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || abort "NVM not found after installation."

# ===============================
# INSTALL NODE.JS LTS AND SET DEFAULT
# ===================================
log "Installing latest Node.js LTS..."
nvm install --lts
log "Setting latest Node.js LTS as default..."
nvm use --lts

# ===============================
# DONE
# ===================================
success "NVM ${NVM_VERSION}, Node.js LTS, and global packages installed successfully!"
