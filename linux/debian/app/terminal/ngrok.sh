#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
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
