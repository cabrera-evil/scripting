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
# INSTALL REQUIRED PACKAGES
# ===================================
log "Installing required packages: pass, gnupg2..."
sudo apt install -y pass gnupg2

# ===================================
# GENERATE GPG KEY
# ===================================
log "Generating a new GPG key..."
gpg --generate-key

# ===================================
# RETRIEVE GPG KEY ID
# ===================================
log "Extracting newly generated GPG key ID..."
gpg_key=$(gpg --list-keys --keyid-format LONG | awk '/^pub/ {print $2}' | cut -d'/' -f2 | head -n1)

[ -z "$gpg_key" ] && die "Could not extract GPG key ID."

# ===================================
# INITIALIZE PASS WITH GPG KEY
# ===================================
log "Initializing pass with GPG key: $gpg_key"
pass init "$gpg_key"

success "pass is now initialized and ready to store Docker Hub credentials."
