#!/usr/bin/env bash
set -euo pipefail

# ================================
# Colors
# ================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ================================
# Logging
# ================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ================================
# Checks
# ================================
for cmd in sudo sed tee; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# Comment out current entries
# ================================
log "Commenting out existing 'deb' entries in /etc/apt/sources.list..."
sudo sed -i 's/^\s*deb /# deb /g' /etc/apt/sources.list

# ================================
# Add new sources
# ================================
log "Adding Debian Bookworm repository entries..."

sudo tee -a /etc/apt/sources.list >/dev/null <<'EOF'
deb http://deb.debian.org/debian/ bookworm contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ bookworm contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
EOF

success "Debian Bookworm repositories updated successfully!"
