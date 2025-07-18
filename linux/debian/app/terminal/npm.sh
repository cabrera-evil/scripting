#!/usr/bin/env bash
set -euo pipefail

# ===============================
# Colors
# ===============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===============================
# Logging
# ===============================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
	echo -e "${RED}✗ $1${NC}" >&2
	exit 1
}

# ===============================
# Checks
# ===============================
for cmd in curl wget bash sudo; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===============================
# Get latest NVM version
# ===============================
log "Fetching latest NVM version..."
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest |
	grep tag_name | sed -E 's/.*"v([^"]+)".*/v\1/')
[ -z "$NVM_VERSION" ] && abort "Unable to determine latest NVM version."

# ===============================
# Install NVM
# ===============================
log "Installing NVM ${NVM_VERSION}..."
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# ===============================
# Source nvm in current session
# ===============================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || abort "NVM not found after installation."

# ===============================
# Install Node.js LTS and set default
# ===============================
log "Installing latest Node.js LTS..."
nvm install --lts
log "Setting latest Node.js LTS as default..."
nvm use --lts

# ===============================
# Install global npm tools
# ===============================
log "Installing global npm packages (npm, yarn, pnpm)..."
npm install -g npm@latest yarn@latest pnpm@latest

# ===============================
# Done
# ===============================
success "NVM ${NVM_VERSION}, Node.js LTS, and global packages installed successfully!"
