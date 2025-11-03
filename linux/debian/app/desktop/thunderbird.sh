#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
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
# DETECT LATEST VERSION
# ===================================
log "Fetching latest Thunderbird version..."
RELEASES_URL="https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/"
ARCH="linux-x86_64"
LOCALE="en-US"

# Get all versions and sort them in reverse order
VERSIONS=$(curl -s "$RELEASES_URL" | grep -oP '\d+\.\d+(\.\d+)?' | sort -Vru | uniq) || die "Unable to retrieve versions."

if [ -z "$VERSIONS" ]; then
	die "Failed to detect any Thunderbird versions."
fi

# Find the first version that has an available download
VERSION=""
for ver in $VERSIONS; do
	log "Checking version $ver..."
	test_url="https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${ver}/${ARCH}/${LOCALE}/thunderbird-${ver}.tar.xz"
	if curl -I -s "$test_url" | head -1 | grep -q "200"; then
		VERSION="$ver"
		log "Found available version: $VERSION"
		break
	fi
done

if [ -z "$VERSION" ]; then
	die "No downloadable Thunderbird version found."
fi

# ===================================
# CONFIG
# ===================================
FILENAME="thunderbird-${VERSION}.tar.xz"
DOWNLOAD_URL="https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${VERSION}/${ARCH}/${LOCALE}/${FILENAME}"
INSTALL_DIR="/opt/thunderbird"
TMP_DIR="$(mktemp -d)"
TMP_TAR="${TMP_DIR}/${FILENAME}"
DESKTOP_ENTRY="/usr/share/applications/thunderbird.desktop"
THUNDERBIRD_BIN="/usr/bin/thunderbird"

log "Download URL: $DOWNLOAD_URL"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading Thunderbird ${VERSION}..."
wget -O "$TMP_TAR" "$DOWNLOAD_URL" || die "Download failed."

# ===================================
# EXTRACT
# ===================================
log "Extracting archive..."
tar -xJf "$TMP_TAR" -C "$TMP_DIR"

# ===================================
# REPLACE EXISTING INSTALLATION
# ===================================
if [ -e "$INSTALL_DIR" ]; then
	log "Removing existing Thunderbird at $INSTALL_DIR..."
	sudo rm -rf "$INSTALL_DIR"
fi

log "Installing Thunderbird to $INSTALL_DIR..."
sudo mv "${TMP_DIR}/thunderbird" "$INSTALL_DIR"

# ===================================
# CREATE .DESKTOP FILE
# ===================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=Thunderbird
GenericName=Email Client
Comment=Send and receive email with Thunderbird
Exec=${INSTALL_DIR}/thunderbird %u
Terminal=false
Type=Application
Icon=${INSTALL_DIR}/chrome/icons/default/default256.png
Categories=Network;Email;
MimeType=message/rfc822;x-scheme-handler/mailto;
StartupNotify=true
StartupWMClass=thunderbird
EOF

# ===================================
# CREATE SYMLINK
# ===================================
if [ -e "$THUNDERBIRD_BIN" ]; then
	log "Removing existing Thunderbird binary link..."
	sudo rm -f "$THUNDERBIRD_BIN"
fi

log "Linking Thunderbird binary to $THUNDERBIRD_BIN..."
sudo ln -s "${INSTALL_DIR}/thunderbird" "$THUNDERBIRD_BIN"

# ===================================
# CLEANUP
# ===================================
log "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

success "Thunderbird ${VERSION} installed successfully!"
