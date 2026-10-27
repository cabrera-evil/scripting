#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	RED=$'\033[0;31m'
	GREEN=$'\033[0;32m'
	YELLOW=$'\033[0;33m'
	BLUE=$'\033[0;34m'
	MAGENTA=$'\033[0;35m'
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' NC=''
fi

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false
GODOT_RELEASES_API="https://api.github.com/repos/godotengine/godot-builds/releases/latest"

# ================================
# LOGGING FUNCTIONS
# ================================
log() { if [[ "$QUIET" != true ]]; then printf "${BLUE}▶${NC} %s\n" "$*"; fi; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { if [[ "$QUIET" != true ]]; then printf "${GREEN}✓${NC} %s\n" "$*"; fi; }
debug() { if [[ "$DEBUG" == true ]]; then printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2; fi; }
die() {
	error "$*"
	exit 1
}

# ================================
# INSTALL GODOT
# ================================
ARCH="$(uname -m)"
[[ "$ARCH" == "x86_64" ]] || die "Unsupported architecture '$ARCH'; Godot installer supports Linux x86_64 only."

for tool in wget jq unzip mktemp sudo install timeout; do
	command -v "$tool" >/dev/null 2>&1 || die "Required tool '$tool' is not installed."
done

TMP_DIR="$(mktemp -d)" || die "Failed to create a temporary directory."
trap 'rm -rf "$TMP_DIR"' EXIT

RELEASE_JSON="$TMP_DIR/release.json"
log "Checking the latest stable Godot release..."
if ! timeout 120 wget --no-config --no-background --tries=3 --timeout=15 --read-timeout=120 \
	-O "$RELEASE_JSON" "$GODOT_RELEASES_API" </dev/null; then
	die "Failed to fetch Godot release metadata from GitHub. Check the network and try again."
fi

ASSET_RECORD="$(jq -er '[.assets[] | select(.name | test("^Godot_v[0-9]+(\\.[0-9]+)*-stable_linux\\.x86_64\\.zip$"))] | if length == 1 then .[0] | [.name, .browser_download_url] | @tsv else empty end' "$RELEASE_JSON")" \
	|| die "Latest Godot release metadata has no unique official stable Linux x86_64 ZIP asset."
IFS=$'\t' read -r ASSET_NAME ASSET_URL <<< "$ASSET_RECORD"
[[ -n "$ASSET_URL" && "$ASSET_URL" == https://github.com/godotengine/godot-builds/releases/download/* ]] \
	|| die "Latest Godot release contains an invalid download URL."
[[ "$ASSET_NAME" =~ ^Godot_v([0-9]+(\.[0-9]+)*)-stable_linux\.x86_64\.zip$ ]] \
	|| die "Latest Godot release contains an invalid stable asset name."
LATEST_VERSION="${BASH_REMATCH[1]}"

if command -v godot >/dev/null 2>&1; then
	INSTALLED_PATH="$(command -v godot)"
	if INSTALLED_OUTPUT="$("$INSTALLED_PATH" --version 2>/dev/null)" &&
		[[ "$INSTALLED_OUTPUT" =~ ^([0-9]+(\.[0-9]+)+)(\.stable|[-+]) ]]; then
		INSTALLED_VERSION="${BASH_REMATCH[1]}"
		if [[ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]]; then
			success "Godot $LATEST_VERSION is already installed."
			exit 0
		fi
		log "Upgrading Godot from $INSTALLED_VERSION to $LATEST_VERSION..."
	else
		warn "Could not determine the installed Godot version; proceeding with the latest stable release."
	fi
else
	log "Installing Godot $LATEST_VERSION..."
fi

ZIP_PATH="$TMP_DIR/godot.zip"
if ! timeout 600 wget --no-config --no-background --tries=3 --timeout=15 --read-timeout=600 \
	-O "$ZIP_PATH" "$ASSET_URL" </dev/null; then
	die "Failed to download Godot $LATEST_VERSION. Check the network and try again."
fi
unzip -tq "$ZIP_PATH" >/dev/null || die "Downloaded Godot archive is invalid or incomplete."

BINARY_NAME="Godot_v${LATEST_VERSION}-stable_linux.x86_64"
ARCHIVE_HAS_BINARY=false
while IFS= read -r entry; do
	if [[ "$entry" == "$BINARY_NAME" ]]; then
		ARCHIVE_HAS_BINARY=true
		break
	fi
done < <(unzip -Z1 "$ZIP_PATH")
[[ "$ARCHIVE_HAS_BINARY" == true ]] || die "Godot archive does not contain the expected editor binary '$BINARY_NAME'."
unzip -p "$ZIP_PATH" "$BINARY_NAME" > "$TMP_DIR/godot" \
	|| die "Failed to extract the Godot editor binary."
[[ -s "$TMP_DIR/godot" ]] || die "Extracted Godot editor binary is empty."

sudo install -o root -g root -m 0755 "$TMP_DIR/godot" /usr/local/bin/godot \
	|| die "Failed to install Godot at /usr/local/bin/godot."

# ================================
# DONE
# ================================
success "Godot $LATEST_VERSION installed successfully at /usr/local/bin/godot."
