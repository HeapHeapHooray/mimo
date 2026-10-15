#!/usr/bin/env bash
#
# install.sh
# Installs minecraft-mods to ~/.local/bin by creating a symlink.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.local/bin"
SOURCE_BIN="${SCRIPT_DIR}/minecraft-mods"
TARGET_BIN="${TARGET_DIR}/minecraft-mods"

mkdir -p "$TARGET_DIR"
chmod +x "$SOURCE_BIN"

ln -sf "$SOURCE_BIN" "$TARGET_BIN"
echo "==> Installed symlink: $TARGET_BIN -> $SOURCE_BIN"

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
echo "    minecraft-mods --help"
