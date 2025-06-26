#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# Logging
# ===================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
command -v git >/dev/null || abort "Command 'git' is required but not found."

# ===================================
# Input
# ===================================
read -rp "$(echo -e "${BLUE}Enter GitHub username: ${NC}")" username
read -rp "$(echo -e "${BLUE}Enter GitHub email: ${NC}")" email

# ===================================
# Git Configuration
# ===================================
log "Setting up Git global username and email..."
git config --global user.name "$username"
git config --global user.email "$email"

success "Git global config updated successfully."
