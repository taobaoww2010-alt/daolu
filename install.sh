#!/bin/bash
# Daolu Installation Script
# Installs daolu (Chinese-localized opencode) from GitHub releases
set -e

REPO="amy12/opencode"  # TODO: Update with actual GitHub repo
DAOLU_DIR="$HOME/.local/bin"
DAOLU_BIN="$DAOLU_DIR/daolu"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Daolu Installation Script${NC}"
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
                *)       echo "linux-x64" ;;
            esac
            ;;
        Darwin*)
            case "$arch" in
                arm64)   echo "darwin-arm64" ;;
                x86_64)  echo "darwin-x64" ;;
                *)       echo "darwin-arm64" ;;
            esac
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows-x64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

PLATFORM=$(detect_platform)
echo -e "${YELLOW}Detected platform: $PLATFORM${NC}"

if [ "$PLATFORM" = "unknown" ]; then
    echo -e "${RED}Error: Unsupported platform${NC}"
    exit 1
fi

# Check if running on server (non-macOS)
if [ "$(uname -s)" = "Linux" ]; then
    echo -e "${YELLOW}Detected Linux server${NC}"
    echo -e "${YELLOW}Building from source...${NC}"
    
    # Check dependencies
    if ! command -v bun &> /dev/null; then
        echo -e "${RED}Error: bun is required${NC}"
        echo "Install bun: curl -fsSL https://bun.sh/install | bash"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is required${NC}"
        exit 1
    fi
    
    # Clone and build
    BUILD_DIR=$(mktemp -d)
    echo "Cloning daolu repository..."
    git clone --depth 1 https://github.com/amy12/opencode.git "$BUILD_DIR/daolu" 2>/dev/null || {
        echo -e "${RED}Error: Failed to clone repository${NC}"
        echo "Please check: https://github.com/amy12/opencode"
        exit 1
    }
    
    cd "$BUILD_DIR/daolu"
    bash script/build.sh
    
    # Install
    mkdir -p "$DAOLU_DIR"
    cp dist/*/bin/opencode "$DAOLU_BIN" 2>/dev/null || {
        echo -e "${RED}Error: Build failed${NC}"
        exit 1
    }
    chmod +x "$DAOLU_BIN"
    
    # Cleanup
    rm -rf "$BUILD_DIR"
    
else
    # macOS - download pre-built binary
    echo "Downloading daolu..."
    
    # Get latest release URL
    LATEST_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -o '"browser_download_url": *"[^"]*'$PLATFORM'[^"]*"' | cut -d'"' -f4)
    
    if [ -z "$LATEST_URL" ]; then
        echo -e "${YELLOW}No pre-built binary found for $PLATFORM${NC}"
        echo -e "${YELLOW}Building from source...${NC}"
        
        # Fallback to build from source
        BUILD_DIR=$(mktemp -d)
        git clone --depth 1 https://github.com/amy12/opencode.git "$BUILD_DIR/daolu"
        cd "$BUILD_DIR/daolu"
        bash script/build.sh
        
        mkdir -p "$DAOLU_DIR"
        cp dist/*/bin/opencode "$DAOLU_BIN"
        chmod +x "$DAOLU_BIN"
        rm -rf "$BUILD_DIR"
    else
        # Download and install
        mkdir -p "$DAOLU_DIR"
        curl -L "$LATEST_URL" -o "$DAOLU_BIN"
        chmod +x "$DAOLU_BIN"
    fi
fi

# Verify installation
echo ""
echo -e "${GREEN}=========================================${NC}"
if [ -f "$DAOLU_BIN" ]; then
    echo -e "${GREEN}  Installation successful!${NC}"
    echo -e "${GREEN}  Binary: $DAOLU_BIN${NC}"
    echo ""
    
    # Show version
    VERSION=$("$DAOLU_BIN" --version 2>/dev/null || echo "unknown")
    echo -e "${GREEN}  Version: $VERSION${NC}"
    echo ""
    
    # Check if in PATH
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
