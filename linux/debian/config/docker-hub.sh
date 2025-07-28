#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != true ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != true ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != true ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != true ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# INSTALL REQUIRED PACKAGES
# ===================================
log "Installing required packages: pass, gnupg2..."
sudo apt install -y pass gnupg2

# ===================================
# GENERATE GPG KEY
# ===================================
log "Generating a new GPG key..."
gpg --generate-key

# ===================================
# RETRIEVE GPG KEY ID
# ===================================
log "Extracting newly generated GPG key ID..."
gpg_key=$(gpg --list-keys --keyid-format LONG | awk '/^pub/ {print $2}' | cut -d'/' -f2 | head -n1)

[ -z "$gpg_key" ] && abort "Could not extract GPG key ID."

# ===================================
# INITIALIZE PASS WITH GPG KEY
# ===================================
log "Initializing pass with GPG key: $gpg_key"
pass init "$gpg_key"

success "pass is now initialized and ready to store Docker Hub credentials."
