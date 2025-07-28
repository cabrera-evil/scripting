#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
BLUE='\e[0;34m'
GREEN='\e[0;32m'
RED='\e[0;31m'
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
for cmd in apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# PACKAGES TO INSTALL
# ===================================
packages=(
	bat             # cat alternative with syntax highlighting
	curl            # data transfer tool
	git             # version control
	git-flow        # branching model support
	htop            # interactive process viewer
	lsd             # modern ls with icons
	ncdu            # disk usage analyzer
	neofetch        # system info display
	ranger          # terminal file manager
	rsync           # fast file synchronization
	tmux            # terminal multiplexer
	trash-cli       # safe file deletion
	unzip           # unzip .zip files
	unrar           # unrar .rar files
	wget            # network downloader
	xclip           # clipboard integration
	zip             # zip compression
	zsh             # powerful shell
	build-essential # gcc, g++, make
	libssl-dev      # SSL dev headers (required for many Node/Python packages)
	resolvconf      # DNS resolution management
	wireguard       # VPN protocol
	net-tools       # ifconfig/netstat (legacy, still useful)
	bluez           # Bluetooth stack
	filezilla       # FTP/SFTP client
	fzf             # fuzzy finder for terminal
	ripgrep         # fast grep alternative
	jq              # JSON processor
	tree            # recursive directory listing
	gnupg           # for GPG key management
	openssh-client  # SSH utilities
	ca-certificates # SSL certs bundle
	dnsutils        # dig, nslookup
	whois           # whois query tool
	vim             # text editor
)

# ===================================
# UPDATE AND INSTALL
# ===================================
log "Updating package lists..."
sudo apt update -y

log "Installing selected packages..."
sudo apt install -y "${packages[@]}"

success "All packages installed successfully!"
