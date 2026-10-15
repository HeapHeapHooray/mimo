#!/usr/bin/env bash
#
# install.sh
# Installs mimo to ~/.local/bin by creating a symlink.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.local/bin"
SOURCE_BIN="${SCRIPT_DIR}/mimo"
TARGET_BIN="${TARGET_DIR}/mimo"

mkdir -p "$TARGET_DIR"
chmod +x "$SOURCE_BIN"

ln -sf "$SOURCE_BIN" "$TARGET_BIN"
echo "==> Installed symlink: $TARGET_BIN -> $SOURCE_BIN"

# Also create backwards-compatible minecraft-mods alias
ln -sf "$SOURCE_BIN" "${TARGET_DIR}/minecraft-mods"
echo "==> Installed alias:   ${TARGET_DIR}/minecraft-mods -> $SOURCE_BIN"

# Check PATH
case ":$PATH:" in
    *":$TARGET_DIR:"*)
        echo "==> '$TARGET_DIR' is in your PATH."
        ;;
    *)
        echo "Notice: '$TARGET_DIR' is not in your current PATH."
        echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
        echo "    export PATH=\"$TARGET_DIR:\$PATH\""
        ;;
esac

echo ""
echo "Installation complete! Try running:"
echo "    mimo --help"
