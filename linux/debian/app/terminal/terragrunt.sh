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
# CONFIG
# ================================
OS="linux"
VERSION="0.97.2"
TAG="v${VERSION}"
ARCH="$(dpkg --print-architecture)"
TMP_DIR="$(mktemp -d)"

# ================================
# ARCH CHECK
# ================================
case "$ARCH" in
amd64) ARCH="amd64" ;;
arm64) ARCH="arm64" ;;
*) die "Unsupported architecture: ${ARCH}" ;;
esac

# ================================
# DOWNLOAD
# ================================
BINARY_NAME="terragrunt_${OS}_${ARCH}"
BIN_URL="https://github.com/gruntwork-io/terragrunt/releases/download/${TAG}/${BINARY_NAME}"
SUMS_URL="https://github.com/gruntwork-io/terragrunt/releases/download/${TAG}/SHA256SUMS"

log "Downloading Terragrunt ${TAG} for ${ARCH}..."
curl -sL "$BIN_URL" -o "${TMP_DIR}/${BINARY_NAME}"
curl -sL "$SUMS_URL" -o "${TMP_DIR}/SHA256SUMS"

# ================================
# VERIFY CHECKSUM
# ================================
log "Verifying checksum..."
CHECKSUM="$(sha256sum "${TMP_DIR}/${BINARY_NAME}" | awk '{print $1}')"
EXPECTED_CHECKSUM="$(awk -v binary="$BINARY_NAME" '$2 == binary {print $1; exit}' "${TMP_DIR}/SHA256SUMS")"

if [[ -z "$EXPECTED_CHECKSUM" ]]; then
	die "Checksum not found for ${BINARY_NAME}."
fi

if [[ "$CHECKSUM" != "$EXPECTED_CHECKSUM" ]]; then
	die "Checksum mismatch for ${BINARY_NAME}."
fi

# ================================
# INSTALL
# ================================
log "Installing Terragrunt to /usr/local/bin..."
sudo install -m 0755 "${TMP_DIR}/${BINARY_NAME}" /usr/local/bin/terragrunt

# ================================
# DONE
# ================================
success "Terragrunt ${TAG} installed successfully."
