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
# LOGGING
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
GPG_URL="https://apt.releases.hashicorp.com/gpg"
KEYRING_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"

# ================================
# INSTALL PREREQUISITES
# ================================
log "Updating package list and installing prerequisites..."
sudo apt update && sudo apt install -y gnupg software-properties-common

# ================================
# INSTALL GPG KEY
# ================================
log "Installing HashiCorp GPG key..."
wget -O- "$GPG_URL" |
	gpg --dearmor |
	sudo tee "$KEYRING_PATH" >/dev/null

# ================================
# VERIFY GPG KEY
# ================================
log "Verifying GPG key fingerprint..."
gpg --no-default-keyring \
	--keyring "$KEYRING_PATH" \
	--fingerprint

# ================================
# ADD REPOSITORY
# ================================
log "Adding HashiCorp repository..."
echo "deb [arch=$ARCH signed-by=$KEYRING_PATH] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# ================================
# UPDATE PACKAGE LIST
# ================================
log "Updating package list with HashiCorp repository..."
sudo apt update

# ================================
# INSTALL TERRAFORM
# ================================
log "Installing Terraform..."
sudo apt install terraform

success "Terraform installed successfully!"
