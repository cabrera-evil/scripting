#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ================================
# shellcheck disable=SC2034
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
log() {
	if [[ "$QUIET" != true ]]; then
		printf "${BLUE}▶${NC} %s\n" "$*"
	fi
}
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() {
	if [[ "$QUIET" != true ]]; then
		printf "${GREEN}✓${NC} %s\n" "$*"
	fi
}
debug() {
	if [[ "$DEBUG" == true ]]; then
		printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2
	fi
}
die() {
	error "$*"
	exit 1
}

# ================================
# SCRIPT CONFIGURATION
# ================================
KEYRING_PATH="/usr/share/keyrings/mullvad-keyring.asc"
REPO_PATH="/etc/apt/sources.list.d/mullvad.list"
KEYRING_URL="https://repository.mullvad.net/deb/mullvad-keyring.asc"
REPO_LINE="deb [signed-by=${KEYRING_PATH} arch=$(dpkg --print-architecture)] https://repository.mullvad.net/deb/stable stable main"

# ================================
# INSTALL MULLVAD VPN
# ================================
log "Downloading Mullvad signing key..."
sudo curl -fsSLo "$KEYRING_PATH" "$KEYRING_URL" || die "Failed to download Mullvad signing key."

log "Adding Mullvad apt repository..."
printf '%s\n' "$REPO_LINE" | sudo tee "$REPO_PATH" >/dev/null || die "Failed to add Mullvad apt repository."

log "Updating apt package index..."
sudo apt update || die "Failed to update apt package index."

log "Installing Mullvad VPN..."
sudo apt install -y mullvad-vpn || die "Failed to install Mullvad VPN."

# ================================
# DONE
# ================================
success "Mullvad VPN installation completed successfully. Use 'mullvad version' to verify."
