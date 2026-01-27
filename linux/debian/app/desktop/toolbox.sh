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
# DETECT LATEST VERSION
# ================================
log "Detecting latest JetBrains Toolbox version..."
TOOLBOX_VERSION=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" |
	jq -r '.TBA[0].build') || die "Failed to fetch Toolbox version"

TOOLBOX_URL="https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/toolbox.tar.gz"
INSTALL_DIR="/opt/jetbrains-toolbox"
BIN_PATH="/usr/local/bin/jetbrains-toolbox"
DESKTOP_ENTRY="/usr/share/applications/jetbrains-toolbox.desktop"

# ================================
# DOWNLOAD
# ================================
log "Downloading JetBrains Toolbox v${TOOLBOX_VERSION}..."
wget -O "$TMP_FILE" "$TOOLBOX_URL"

# ================================
# EXTRACT
# ================================
log "Extracting archive..."
tar -xzf "$TMP_FILE" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'jetbrains-toolbox-*' | head -n1)"

# ================================
# INSTALL
# ================================
log "Installing to ${INSTALL_DIR}..."
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# ================================
# SYMLINK
# ================================
log "Creating symlink at /usr/local/bin..."
sudo ln -sf "${INSTALL_DIR}/bin/jetbrains-toolbox" "$BIN_PATH"

# ================================
# DESKTOP ENTRY
# ================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=JetBrains Toolbox
GenericName=JetBrains Toolbox
Comment=Manage JetBrains IDEs
Exec=${INSTALL_DIR}/bin/jetbrains-toolbox
Icon=${INSTALL_DIR}/bin/toolbox-tray-color.png
Terminal=false
Type=Application
Categories=Development;
EOF

success "JetBrains Toolbox v${TOOLBOX_VERSION} installed successfully. Run with 'jetbrains-toolbox'."
