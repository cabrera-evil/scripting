#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
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

# ================================
# CHECKS
# ===================================
for cmd in sudo sed tee; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# COMMENT OUT CURRENT ENTRIES
# ===================================
log "Commenting out existing 'deb' entries in /etc/apt/sources.list..."
sudo sed -i 's/^\s*deb /# deb /g' /etc/apt/sources.list

# ================================
# ADD NEW SOURCES
# ===================================
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
