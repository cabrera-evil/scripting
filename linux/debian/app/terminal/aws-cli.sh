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
# CHECKS
# ===================================
for cmd in curl wget unzip sudo; do
  command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(uname -m)"
URL="https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading AWS CLI v2 for ${ARCH}..."
wget -O "$TMP_ZIP" "$URL"

# ===================================
# EXTRACT
# ===================================
log "Unpacking installer..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# INSTALL
# ===================================
log "Installing AWS CLI..."
sudo "${TMP_DIR}/aws/install" --update

success "AWS CLI v2 installed successfully!"
