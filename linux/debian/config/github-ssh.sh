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

[ -z "$email" ] && die "Email cannot be empty."

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
