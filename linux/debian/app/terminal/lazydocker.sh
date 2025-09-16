#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# CHECKS
# ===================================
for cmd in curl tar grep sed uname; do
    command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===============================
# CONFIG
# ===================================
ARCH=$(uname -m)
TMP_DIR="$(mktemp -d)"
BIN_PATH="/usr/local/bin/lazydocker"

# Map architecture
case "$ARCH" in
x86_64) ARCH="Linux_x86_64" ;;
aarch64) ARCH="Linux_arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# DETECT LATEST VERSION
# ===================================
log "Fetching latest version of Lazydocker..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')
[ -z "$VERSION" ] && die "Unable to determine latest version."

# ===============================
# DOWNLOAD
# ===================================
TARBALL="lazydocker_${VERSION}_${ARCH}.tar.gz"
URL="https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/${TARBALL}"

log "Downloading Lazydocker v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/${TARBALL}"

log "Extracting..."
tar -xzf "${TMP_DIR}/${TARBALL}" -C "$TMP_DIR"

# ===============================
# INSTALL
# ===================================
log "Installing to ${BIN_PATH}..."
sudo mv "${TMP_DIR}/lazydocker" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# ===============================
# DONE
# ===================================
success "Lazydocker v${VERSION} installed successfully."
