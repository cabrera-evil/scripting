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
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in git ssh-keygen ssh-add xclip xdg-open pgrep; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# GIT EMAIL
# ===================================
email="$(git config user.email || true)"

if [ -z "$email" ]; then
    read -rp "$(echo -e "${BLUE}Git email is not set. Enter your GitHub email: ${NC}")" email
else
    log "Detected Git email: $email"
    read -rp "Do you want to override this email? (y/N): " override_email
    if [[ "$override_email" =~ ^[Yy]$ ]]; then
        read -rp "Enter new GitHub email: " email
    fi
fi

[ -z "$email" ] && abort "Email cannot be empty."

# ===================================
# SSH KEY NAME
# ===================================
default_key="id_ed25519"
key_path="$HOME/.ssh/$default_key"

log "Default SSH key: $default_key"
read -rp "Do you want to use a different key name? (y/N): " override_key
if [[ "$override_key" =~ ^[Yy]$ ]]; then
    read -rp "Enter SSH key name: " custom_key
    key_path="$HOME/.ssh/$custom_key"
fi

# ===================================
# GENERATE SSH KEY
# ===================================
log "Generating SSH key..."
ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""

# ===================================
# START SSH AGENT
# ===================================
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    log "Starting SSH agent..."
    eval "$(ssh-agent -s)"
fi

ssh-add "$key_path"

# ===================================
# COPY TO CLIPBOARD
# ===================================
log "Copying public key to clipboard..."
xclip -selection clipboard <"$key_path.pub"

# ===================================
# DISPLAY PUBLIC KEY
# ===================================
log "Public key content:"
cat "$key_path.pub"

# ===================================
# FINAL INSTRUCTIONS
# ===================================
log "The public key has been copied to the clipboard."
read -rp "Press Enter to open GitHub SSH settings in your browser..."
xdg-open "https://github.com/settings/ssh/new"

success "SSH key generated, added to agent, and copied to clipboard."
