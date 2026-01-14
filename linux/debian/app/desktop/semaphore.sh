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
# CONFIG
# ================================
ARCH="$(dpkg --print-architecture)"
TMP_DIR="$(mktemp -d)"

# ================================
# ARCH CHECK
# ================================
if [[ "$ARCH" != "amd64" ]]; then
	die "Unsupported architecture: ${ARCH} (requires amd64)"
fi

# ================================
# DETECT LATEST VERSION
# ================================
log "Fetching latest Semaphore version..."
VERSION=$(curl -s https://api.github.com/repos/semaphoreui/semaphore/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
[ -z "$VERSION" ] && die "Unable to detect latest version."

# ================================
# CONFIG
# ================================
URL="https://github.com/semaphoreui/semaphore/releases/download/v${VERSION}/semaphore_${VERSION}_linux_amd64.tar.gz"

# ================================
# DOWNLOAD AND EXTRACT
# ================================
log "Downloading Semaphore v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/semaphore.tar.gz"

log "Extracting..."
tar -xzf "${TMP_DIR}/semaphore.tar.gz" -C "$TMP_DIR"

# ================================
# INSTALL
# ================================
log "Installing Semaphore to /usr/local/bin..."
sudo install -m 0755 "${TMP_DIR}/semaphore" /usr/local/bin/semaphore

# ================================
# DONE
# ================================
success "Semaphore v${VERSION} installed successfully."
