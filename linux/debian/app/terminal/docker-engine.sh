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
# SETUP REPOSITORY
# ================================
log "Setting up Docker repository..."
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

ARCH=$(dpkg --print-architecture)
CODENAME=$(source /etc/os-release && echo "$VERSION_CODENAME")

echo \
	"deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update -y

# ================================
# INSTALL DOCKER COMPONENTS
# ================================
log "Installing Docker Engine and components..."
sudo apt install -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin

# ================================
# POST-INSTALL SETUP
# ================================
log "Adding current user to docker group..."
sudo usermod -aG docker "$USER"

# ================================
# UPDATE /ETC/HOSTS
# ================================
log "Ensuring 'host.docker.internal' is in /etc/hosts..."

if grep -qE '^127\.0\.0\.1\s+.*localhost' /etc/hosts; then
	if ! grep -qE '^127\.0\.0\.1\s+.*\bhost\.docker\.internal\b' /etc/hosts; then
		sudo sed -i -E 's/^(127\.0\.0\.1\s+.*\blocalhost\b)(.*)/\1 host.docker.internal\2/' /etc/hosts
		success "'host.docker.internal' added to 127.0.0.1 entry in /etc/hosts."
	else
		success "'host.docker.internal' is already present in /etc/hosts."
	fi
else
	die "No '127.0.0.1 localhost' entry found in /etc/hosts. Please add one manually."
fi

# ==================================
# ENABLE DOCKER SERVICES
# ================================
log "Enabling Docker and containerd services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

success "Docker installation and configuration complete!"
