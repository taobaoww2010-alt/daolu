#!/bin/bash
# Daolu Installation Script
# Installs daolu (Chinese-localized opencode) from GitHub releases
set -e

REPO="taobaoww2010-alt/daolu"
DAOLU_DIR="$HOME/.local/bin"
DAOLU_BIN="$DAOLU_DIR/daolu"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Daolu (道路) Installation Script${NC}"
echo -e "${GREEN}  Chinese-localized opencode${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# Detect platform
detect_platform() {
    local os=$(uname -s)
    local arch=$(uname -m)
    case "$os" in
        Linux*)
            case "$arch" in
                x86_64)  echo "linux-x64" ;;
                aarch64) echo "linux-arm64" ;;
                *)       echo "unknown" ;;
            esac ;;
        Darwin*)
            case "$arch" in
                arm64)   echo "darwin-arm64" ;;
                x86_64)  echo "darwin-x64" ;;
                *)       echo "unknown" ;;
            esac ;;
        *) echo "unknown" ;;
    esac
}

PLATFORM=$(detect_platform)
echo -e "${YELLOW}Detected platform: $PLATFORM${NC}"

if [ "$PLATFORM" = "unknown" ]; then
    echo -e "${RED}Error: Unsupported platform ($(uname -s)/$(uname -m))${NC}"
    echo "Supported: darwin-arm64, darwin-x64, linux-x64, linux-arm64"
    exit 1
fi

# Download pre-built binary
echo "Downloading daolu..."

# Get download URL from latest release
LATEST_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -o "\"browser_download_url\": *\"[^\"]*daolu-${PLATFORM}[^\"]*\"" \
    | head -1 \
    | cut -d'"' -f4)

if [ -z "$LATEST_URL" ]; then
    echo -e "${RED}Error: No pre-built binary found for $PLATFORM${NC}"
    echo "Check: https://github.com/$REPO/releases"
    exit 1
fi

echo -e "${YELLOW}Download URL: $LATEST_URL${NC}"

# Create directory and download
mkdir -p "$DAOLU_DIR"
curl -fSL "$LATEST_URL" -o "$DAOLU_BIN"
chmod +x "$DAOLU_BIN"

# Verify
echo ""
echo -e "${GREEN}=========================================${NC}"
if [ -f "$DAOLU_BIN" ]; then
    VERSION=$("$DAOLU_BIN" --version 2>/dev/null || echo "unknown")
    echo -e "${GREEN}  Installation successful!${NC}"
    echo -e "${GREEN}  Binary: $DAOLU_BIN${NC}"
    echo -e "${GREEN}  Version: $VERSION${NC}"
    echo ""

    if [[ ":$PATH:" != *":$DAOLU_DIR:"* ]]; then
        echo -e "${YELLOW}  Note: Add to your PATH:${NC}"
        echo -e "${YELLOW}    export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    fi

    echo ""
    echo -e "${GREEN}  Usage: daolu${NC}"
    echo -e "${GREEN}=========================================${NC}"
else
    echo -e "${RED}  Installation failed${NC}"
    echo -e "${RED}=========================================${NC}"
    exit 1
fi
