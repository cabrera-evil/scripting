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
ARCH="linux_amd64"
TMP_DIR="$(mktemp -d)"
BIN_PATH="/usr/local/bin/kustomize"

# ===================================
# DETECT LATEST VERSION
# ===================================
log "Detecting latest version of kustomize..."
LATEST_TAG=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep tag_name | sed -E 's/.*"v([0-9.]+)".*/\1/')
[ -z "$LATEST_TAG" ] && die "Failed to detect latest version."

# ===================================
# DOWNLOAD AND EXTRACT
# ===================================
FILENAME="kustomize_v${LATEST_TAG}_${ARCH}.tar.gz"
URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${LATEST_TAG}/${FILENAME}"

log "Downloading kustomize v${LATEST_TAG}..."
curl -sL "$URL" -o "${TMP_DIR}/${FILENAME}"

log "Extracting..."
tar -xf "${TMP_DIR}/${FILENAME}" -C "$TMP_DIR"

# ===================================
# INSTALL
# ===================================
log "Installing to ${BIN_PATH}..."
sudo mv "${TMP_DIR}/kustomize" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# ===================================
# DONE
# ===================================
success "kustomize v${LATEST_TAG} installed successfully."
