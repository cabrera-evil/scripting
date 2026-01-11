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
KEY_URL="https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367"
KEYRING_PATH="/usr/share/keyrings/ansible-archive-keyring.gpg"
PPA_URL="http://ppa.launchpad.net/ansible/ansible/ubuntu"

# ================================
# DETERMINE UBUNTU CODENAME
# ================================
UBUNTU_CODENAME="${UBUNTU_CODENAME:-}"
if [[ -z "$UBUNTU_CODENAME" ]]; then
	DEBIAN_VERSION=$(source /etc/os-release && echo "${VERSION_ID:-}")
	case "$DEBIAN_VERSION" in
		"13") UBUNTU_CODENAME="noble" ;;
		"12") UBUNTU_CODENAME="jammy" ;;
		"11") UBUNTU_CODENAME="focal" ;;
		"10") UBUNTU_CODENAME="bionic" ;;
		*)
			die "Unsupported Debian version '$DEBIAN_VERSION'. Set UBUNTU_CODENAME to a supported Ubuntu release."
			;;
	esac
fi

log "Using Ubuntu codename: $UBUNTU_CODENAME"

# ================================
# INSTALL PREREQUISITES
# ================================
log "Updating package list and installing prerequisites..."
sudo apt update
sudo apt install -y wget gnupg

# ================================
# INSTALL GPG KEY
# ================================
log "Installing Ansible GPG key..."
wget -O - "$KEY_URL" |
	sudo gpg --dearmor -o "$KEYRING_PATH"

# ================================
# ADD REPOSITORY
# ================================
log "Adding Ansible repository..."
echo "deb [signed-by=$KEYRING_PATH] $PPA_URL $UBUNTU_CODENAME main" |
	sudo tee /etc/apt/sources.list.d/ansible.list >/dev/null

# ================================
# INSTALL ANSIBLE
# ================================
log "Updating package list with Ansible repository..."
sudo apt update

log "Installing Ansible..."
sudo apt install -y ansible

success "Ansible installed successfully!"
