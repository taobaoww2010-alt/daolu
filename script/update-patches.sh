#!/bin/bash
# Update patches from opencode-dev source
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="${OPENCODE_SOURCE_DIR:-/Users/amyyu12/Downloads/opencode-dev}"
PATCHES_DIR="$ROOT_DIR/patches"

echo "Updating patches from $SOURCE_DIR..."

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Clear old patches
rm -rf "$PATCHES_DIR/packages"
mkdir -p "$PATCHES_DIR/packages"

# Copy TUI patches
echo "Copying TUI patches..."
TUI_SRC="$SOURCE_DIR/packages/tui/src"
TUI_DST="$PATCHES_DIR/packages/tui/src"
mkdir -p "$TUI_DST"

# Copy patched files
for file in \
    util/zh.ts \
    logo.ts \
    app.tsx \
    component/dialog-provider.tsx \
    component/dialog-move-session.tsx \
    component/dialog-session-list.tsx \
    component/dialog-console-org.tsx \
    component/dialog-workspace-create.tsx \
    component/dialog-workspace-list.tsx \
    component/dialog-workspace-unavailable.tsx \
    component/dialog-workspace-file-changes.tsx \
    component/dialog-model.tsx \
    component/dialog-mcp.tsx \
    component/dialog-skill.tsx \
    component/dialog-agent.tsx \
    component/dialog-stash.tsx \
    component/dialog-debug.tsx \
    component/dialog-status.tsx \
    component/dialog-export-options.tsx \
    component/dialog-help.tsx \
    component/dialog-select.tsx \
    component/dialog-retry-action.tsx \
    component/dialog-session-rename.tsx \
    component/dialog-session-delete-failed.tsx \
    component/dialog-theme-list.tsx \
    component/dialog-variant.tsx \
    component/command-palette.tsx \
    component/error-component.tsx \
    component/plugin-route-missing.tsx \
    component/startup-loading.tsx \
    component/prompt/index.tsx \
    component/prompt/move.tsx \
    component/prompt/workspace.tsx \
    component/prompt/autocomplete.tsx \
    feature-plugins/home/tips-view.tsx \
    feature-plugins/home/tips.tsx \
    feature-plugins/home/footer.tsx \
    feature-plugins/sidebar/footer.tsx \
    feature-plugins/system/diff-viewer.tsx \
    feature-plugins/system/diff-viewer-file-tree.tsx \
    feature-plugins/system/plugins.tsx \
    feature-plugins/system/which-key.tsx \
    context/local.tsx \
    routes/home.tsx \
    routes/session/index.tsx \
    routes/session/footer.tsx \
    routes/session/permission.tsx \
    routes/session/question.tsx \
    routes/session/dialog-timeline.tsx \
    routes/session/dialog-subagent.tsx \
    routes/session/dialog-message.tsx \
    routes/session/dialog-fork-from-timeline.tsx \
    routes/session/subagent-footer.tsx \
    ui/dialog.tsx \
    ui/toast.tsx \
    ui/dialog-help.tsx \
    ui/dialog-select.tsx \
    ui/dialog-export-options.tsx \
    util/selection.ts; do
    
    src_file="$TUI_SRC/$file"
    dst_file="$TUI_DST/$file"
    
    if [ -f "$src_file" ]; then
        mkdir -p "$(dirname "$dst_file")"
        cp "$src_file" "$dst_file"
        echo "  ✓ $file"
    fi
done

# Copy TUI package.json
cp "$SOURCE_DIR/packages/tui/package.json" "$PATCHES_DIR/packages/tui/package.json"
echo "  ✓ package.json"

# Copy opencode patches
echo "Copying opencode patches..."
OPENCODE_SRC="$SOURCE_DIR/packages/opencode/src/cli/cmd/run"
OPENCODE_DST="$PATCHES_DIR/packages/opencode/src/cli/cmd/run"
mkdir -p "$OPENCODE_DST"

for file in \
    splash.ts \
    tool.ts \
    footer.permission.tsx \
    footer.question.tsx \
    permission.shared.ts \
    footer.menu.tsx \
    footer.prompt.tsx \
    footer.view.tsx \
    footer.command.tsx; do
    
    src_file="$OPENCODE_SRC/$file"
    dst_file="$OPENCODE_DST/$file"
    
    if [ -f "$src_file" ]; then
        mkdir -p "$(dirname "$dst_file")"
        cp "$src_file" "$dst_file"
        echo "  ✓ $file"
    fi
done

echo ""
echo "Patches updated successfully!"
echo "Total files: $(find "$PATCHES_DIR" -type f | wc -l)"
