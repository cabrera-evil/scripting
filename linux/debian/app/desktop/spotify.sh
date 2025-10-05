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
# CONFIG
# ================================
SPOTIFY_KEY_URL="https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg"
SPOTIFY_KEY_PATH="/etc/apt/trusted.gpg.d/spotify.gpg"
SPOTIFY_LIST_PATH="/etc/apt/sources.list.d/spotify.list"
SPOTIFY_REPO="deb https://repository.spotify.com stable non-free"

# ================================
# ADD REPOSITORY
# ================================
log "Setting up the Spotify repository..."
curl -sS "$SPOTIFY_KEY_URL" | sudo gpg --dearmor --yes -o "$SPOTIFY_KEY_PATH"
echo "$SPOTIFY_REPO" | sudo tee "$SPOTIFY_LIST_PATH" >/dev/null

# ================================
# UPDATE PACKAGES
# ================================
log "Updating package list..."
sudo apt update

# ================================
# INSTALL SPOTIFY
# ================================
log "Installing Spotify..."
sudo apt install -y spotify-client

success "Spotify installation complete!"
