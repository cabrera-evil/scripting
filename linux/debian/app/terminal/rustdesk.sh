#!/usr/bin/env bash
set -euo pipefail

# ===============================
# COLORS
# ===============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===============================
# GLOBAL CONFIGURATION
# ===============================
SILENT=false

# ===============================
# LOGGING
# ===============================
log() {
	if [ "$SILENT" != true ]; then
		echo -e "${BLUE}==> $1${NC}"
	fi
}
warn() {
	if [ "$SILENT" != true ]; then
		echo -e "${YELLOW}⚠️  $1${NC}" >&2
	fi
}
success() {
	if [ "$SILENT" != true ]; then
		echo -e "${GREEN}✓ $1${NC}"
	fi
}
abort() {
	if [ "$SILENT" != true ]; then
		echo -e "${RED}✗ $1${NC}" >&2
	fi
	exit 1
}

# ===============================
# CHECKS
# ===============================
for cmd in curl grep sed uname; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# Debian-based only
if ! command -v dpkg >/dev/null; then
	abort "This installer currently supports Debian/Ubuntu (requires 'dpkg')."
fi

APT_CMD=""
if command -v apt-get >/dev/null; then
	APT_CMD="apt-get"
elif command -v apt >/dev/null; then
	APT_CMD="apt"
else
	abort "Neither 'apt-get' nor 'apt' found; cannot resolve dependencies."
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
	abort "Unsupported architecture: $ARCH_RAW"
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
	abort "Download failed from: $URL"
}

# ===============================
# INSTALL
# ===============================
log "Installing ${DEB}..."
# Try apt to handle dependencies automatically if available
if [ "$APT_CMD" = "apt-get" ] || [ "$APT_CMD" = "apt" ]; then
	# Modern apt supports installing local debs directly
	sudo "$APT_CMD" update -y >/dev/null 2>&1 || true
	if sudo "$APT_CMD" install -y "${TMP_DIR}/${DEB}"; then
		:
	else
		warn "apt install failed; attempting dpkg -i then fix dependencies."
		sudo dpkg -i "${TMP_DIR}/${DEB}" || true
		sudo "$APT_CMD" -f install -y
	fi
else
	# Fallback path (shouldn't hit because we gate on apt/dpkg earlier)
	sudo dpkg -i "${TMP_DIR}/${DEB}" || true
	sudo apt-get -f install -y
fi

# ===============================
# VERIFY
# ===============================
if command -v rustdesk >/dev/null; then
	RD_VER="$(rustdesk --version 2>/dev/null || true)"
	success "RustDesk installed successfully. ${RD_VER:-}"
else
	warn "RustDesk binary not found in PATH, but package installation completed."
	echo "Try running: /usr/lib/rustdesk/rustdesk or reboot if needed."
fi
