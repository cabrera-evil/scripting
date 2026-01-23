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
fi

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
# SCRIPT CONFIGURATION
# ================================
KEYRING_DIR="/etc/apt/keyrings"
KEYRING_FILE="${KEYRING_DIR}/antigravity-repo-key.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/antigravity.list"
REPO_GPG_URL="https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg"
REPO_URL="https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/"

# ================================
# SETUP
# ================================
log "Creating keyring directory..."
sudo mkdir -p -m 755 "$KEYRING_DIR"

log "Downloading Antigravity keyring..."
curl -fsSL "$REPO_GPG_URL" | sudo gpg --dearmor --yes -o "$KEYRING_FILE"

log "Setting permissions on keyring..."
sudo chmod go+r "$KEYRING_FILE"

log "Adding Antigravity APT repository..."
echo "deb [signed-by=${KEYRING_FILE}] ${REPO_URL} antigravity-debian main" | sudo tee "$SOURCE_LIST" >/dev/null

# ================================
# INSTALL
# ================================
log "Updating APT package list..."
sudo apt update -y

log "Installing Antigravity..."
sudo apt install -y antigravity

success "Antigravity installation complete!"
