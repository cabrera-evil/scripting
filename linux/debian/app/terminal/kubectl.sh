#!/usr/bin/env bash
set -euo pipefail

# ===================================
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

# ===================================
# CHECKS
# ===================================
for cmd in wget sudo install dpkg; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
KUBECTL_VERSION="$(wget -qO- https://dl.k8s.io/release/stable.txt)"
URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"
TMP_BIN="$(mktemp)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading kubectl ${KUBECTL_VERSION} for ${ARCH}..."
wget -O "$TMP_BIN" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 "$TMP_BIN" /usr/local/bin/kubectl

# ===================================
# AUTOCOMPLETION
# ===================================
log "Enabling bash autocompletion for kubectl..."
if ! grep -q "source <(kubectl completion bash)" ~/.bashrc; then
	echo "source <(kubectl completion bash)" >>~/.bashrc
fi

# ===================================
# DONE
# ===================================
success "kubectl ${KUBECTL_VERSION} installed successfully."
