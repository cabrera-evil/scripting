#!/usr/bin/env bash
set -euo pipefail

# ===================================
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
fi

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
# CONFIG
# ===================================
ARCH=$(dpkg --print-architecture)
KEYRING_DIR="/etc/apt/keyrings"
KEYRING_FILE="$KEYRING_DIR/githubcli-archive-keyring.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/github-cli.list"
REPO_URL="https://cli.github.com/packages"

# ===================================
# SETUP
# ===================================
log "Creating keyring directory..."
sudo mkdir -p -m 755 "$KEYRING_DIR"

log "Downloading GitHub CLI keyring..."
wget -qO- "${REPO_URL}/githubcli-archive-keyring.gpg" | sudo tee "$KEYRING_FILE" >/dev/null

log "Setting permissions on keyring..."
sudo chmod go+r "$KEYRING_FILE"

log "Adding GitHub CLI APT repository..."
echo "deb [arch=${ARCH} signed-by=${KEYRING_FILE}] ${REPO_URL} stable main" | sudo tee "$SOURCE_LIST" >/dev/null

# ===================================
# INSTALL
# ===================================
log "Updating APT package list..."
sudo apt update -y

log "Installing GitHub CLI (gh)..."
sudo apt install -y gh

success "GitHub CLI installation complete!"
