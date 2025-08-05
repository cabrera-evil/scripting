#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
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

# ===================================
# CHECKS
# ===================================
for cmd in curl apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# INSTALL
# ===================================
log "Installing speedtest-cli..."
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt install -y speedtest
success "speedtest-cli installed successfully!"
