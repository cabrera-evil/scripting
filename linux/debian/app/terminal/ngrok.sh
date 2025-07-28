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
# CHECKS
# ===================================
for cmd in curl sudo tee apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# ADD GPG KEY AND REPOSITORY
# ===================================
log "Adding Ngrok GPG key..."
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc |
	sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null

log "Adding Ngrok APT source..."
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" |
	sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null

# ===================================
# INSTALL PACKAGE
# ===================================
log "Updating package lists..."
sudo apt update -y

log "Installing Ngrok..."
sudo apt install -y ngrok

success "Ngrok installation complete!"
