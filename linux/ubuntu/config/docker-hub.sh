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
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
for cmd in gpg pass awk grep cut sudo; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Install Required Packages
# ===================================
log "Installing required packages: pass, gnupg2..."
sudo apt install -y pass gnupg2

# ===================================
# Generate GPG Key
# ===================================
log "Generating a new GPG key..."
gpg --generate-key

# ===================================
# Retrieve GPG Key ID
# ===================================
log "Extracting newly generated GPG key ID..."
gpg_key=$(gpg --list-keys --keyid-format LONG | awk '/^pub/ {print $2}' | cut -d'/' -f2 | head -n1)

[ -z "$gpg_key" ] && abort "Could not extract GPG key ID."

# ===================================
# Initialize pass with GPG key
# ===================================
log "Initializing pass with GPG key: $gpg_key"
pass init "$gpg_key"

success "pass is now initialized and ready to store Docker Hub credentials."
