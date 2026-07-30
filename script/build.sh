#!/bin/bash
# Daolu Build Script
# Builds daolu (Chinese-localized opencode) from source
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OPENCODE_VERSION="${OPENCODE_VERSION:-1.18.2}"
BUILD_DIR="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/dist"

echo "========================================="
echo "  Daolu Build Script"
echo "  opencode version: $OPENCODE_VERSION"
echo "========================================="

# Step 1: Clone opencode if not exists
if [ ! -d "$BUILD_DIR/opencode" ]; then
    echo "[1/5] Cloning opencode v$OPENCODE_VERSION..."
    git clone --depth 1 --branch "v$OPENCODE_VERSION" https://github.com/anomalyco/opencode.git "$BUILD_DIR/opencode" 2>/dev/null || {
        echo "Warning: Failed to clone specific version, trying latest..."
        git clone --depth 1 https://github.com/anomalyco/opencode.git "$BUILD_DIR/opencode"
    }
else
    echo "[1/5] opencode already cloned"
fi

# Step 2: Apply patches
echo "[2/5] Applying daolu patches..."
cd "$BUILD_DIR/opencode"

# Copy patched files over original
find "$ROOT_DIR/patches" -type f | while read -r patch_file; do
    relative_path="${patch_file#$ROOT_DIR/patches/}"
    target_file="$BUILD_DIR/opencode/$relative_path"
    target_dir="$(dirname "$target_file")"
    mkdir -p "$target_dir"
    cp "$patch_file" "$target_file"
    echo "  Applied: $relative_path"
done

# Step 3: Install dependencies
echo "[3/5] Installing dependencies..."
bun install

# Step 4: Build
echo "[4/5] Building..."
export OPENCODE_VERSION="$OPENCODE_VERSION"
export OPENCODE_CHANNEL="latest"
bun run packages/opencode/script/build.ts --single

# Step 5: Copy output
echo "[5/5] Copying build output..."
mkdir -p "$OUTPUT_DIR"
cp -r packages/opencode/dist/* "$OUTPUT_DIR/"

echo ""
echo "========================================="
echo "  Build complete!"
echo "  Output: $OUTPUT_DIR"
echo "========================================="
