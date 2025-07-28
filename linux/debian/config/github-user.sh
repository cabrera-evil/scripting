#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != true ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != true ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != true ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != true ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
command -v git >/dev/null || abort "Command 'git' is required but not found."

# ===================================
# INPUT
# ===================================
read -rp "$(echo -e "${BLUE}Enter GitHub username: ${NC}")" username
read -rp "$(echo -e "${BLUE}Enter GitHub email: ${NC}")" email

# ===================================
# GIT CONFIGURATION
# ===================================
log "Setting up Git global username and email..."
git config --global user.name "$username"
git config --global user.email "$email"

success "Git global config updated successfully."
