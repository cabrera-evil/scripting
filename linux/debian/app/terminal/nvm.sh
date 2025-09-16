#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# GET LATEST NVM VERSION
# ===================================
log "Fetching latest NVM version..."
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest |
	grep tag_name | sed -E 's/.*"v([^"]+)".*/v\1/')
[ -z "$NVM_VERSION" ] && die "Unable to determine latest NVM version."

# ===============================
# INSTALL NVM
# ===================================
log "Installing NVM ${NVM_VERSION}..."
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# ===============================
# SOURCE NVM IN CURRENT SESSION
# ===================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || die "NVM not found after installation."

# ===============================
# INSTALL NODE.JS LTS AND SET DEFAULT
# ===================================
log "Installing latest Node.js LTS..."
nvm install --lts
log "Setting latest Node.js LTS as default..."
nvm use --lts

# ===============================
# DONE
# ===================================
success "NVM ${NVM_VERSION}, Node.js LTS, and global packages installed successfully!"
