#!/usr/bin/env bash
set -euo pipefail

# ===============================
# COLORS
# ===============================
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

# ===============================
# GLOBAL CONFIGURATION
# ===============================
QUIET=false
DEBUG=false

# ===============================
# LOGGING
# ===============================
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
# ===============================
if ! command -v dpkg >/dev/null; then
	die "This installer currently supports Debian/Ubuntu (requires 'dpkg')."
fi

# ===============================
# CONFIG
# ===============================
ARCH_RAW="$(uname -m)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Map architecture -> RustDesk asset suffix
case "$ARCH_RAW" in
x86_64 | amd64) ARCH_DEB="x86_64" ;;
aarch64 | arm64) ARCH_DEB="aarch64" ;;
*)
	die "Unsupported architecture: $ARCH_RAW"
	;;
esac

# ===============================
# DETECT LATEST VERSION
# ===============================
log "Fetching latest RustDesk version..."
VERSION="$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')"
if [ -z "${VERSION:-}" ]; then
	warn "Unable to determine latest version via API. Falling back to 1.4.1."
	VERSION="1.4.1"
fi

# NOTE: RustDesk tags are like "1.4.1" (no leading 'v')
# ===============================
# DOWNLOAD
# ===============================
DEB="rustdesk-${VERSION}-${ARCH_DEB}.deb"
URL="https://github.com/rustdesk/rustdesk/releases/download/${VERSION}/${DEB}"

log "Downloading RustDesk ${VERSION} (${ARCH_DEB})..."
curl -fL --retry 3 "$URL" -o "${TMP_DIR}/${DEB}" || {
	die "Download failed from: $URL"
}

# ===============================
# INSTALL
# ===============================
log "Installing ${DEB}..."
sudo apt update -y >/dev/null 2>&1 || true
sudo apt install -y "${TMP_DIR}/${DEB}"

success "RustDesk installed successfully."