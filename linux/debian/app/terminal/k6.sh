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
K6_GPG_KEY="C5AD17C747E3415A3642D57D77C6C491D6AC1D69"
KEYRING_PATH="/usr/share/keyrings/k6-archive-keyring.gpg"
SOURCES_LIST="/etc/apt/sources.list.d/k6.list"
KEYSERVER="hkp://keyserver.ubuntu.com:80"

# ================================
# ADD GPG KEY
# ================================
log "Adding k6 GPG key to keyring..."
sudo gpg --no-default-keyring --keyring "$KEYRING_PATH" --keyserver "$KEYSERVER" --recv-keys "$K6_GPG_KEY"

# ================================
# ADD REPOSITORY
# ================================
log "Adding k6 repository to sources list..."
echo "deb [signed-by=${KEYRING_PATH}] https://dl.k6.io/deb stable main" | sudo tee "$SOURCES_LIST" >/dev/null

# ================================
# UPDATE APT
# ================================
log "Updating package lists..."
sudo apt-get update

# ================================
# INSTALL
# ================================
log "Installing k6..."
sudo apt-get install -y k6

success "k6 installed successfully"
