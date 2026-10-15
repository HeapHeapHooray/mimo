#!/usr/bin/env bash
#
# install.sh
# Installs mimo to ~/.local/bin.
# Can be run standalone or from the repository clone.
# Repository: https://github.com/HeapHeapHooray/mimo
#

set -euo pipefail

MIMO_URL="https://raw.githubusercontent.com/HeapHeapHooray/mimo/refs/heads/main/mimo"
TARGET_DIR="${HOME}/.local/bin"
TARGET_BIN="${TARGET_DIR}/mimo"
ALIAS_BIN="${TARGET_DIR}/minecraft-mods"

# Parse CLI arguments
FORCE_REMOTE=false
LINK_LOCAL=false

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install mimo to ~/.local/bin

Options:
  -r, --remote   Force downloading latest mimo from GitHub even if local copy exists
  -l, --link     Create symlink to local mimo instead of copying (when run from repo)
  -h, --help     Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--remote)
            FORCE_REMOTE=true
            shift
            ;;
        -l|--link)
            LINK_LOCAL=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option '$1'" >&2
            print_usage >&2
            exit 1
            ;;
    esac
done

mkdir -p "$TARGET_DIR"

# Check if running from a local checkout with mimo present
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "/dev/stdin" && "${BASH_SOURCE[0]}" != "-" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
fi

USE_LOCAL=false
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/mimo" && "$FORCE_REMOTE" == false ]]; then
    USE_LOCAL=true
fi

if [[ "$USE_LOCAL" == true ]]; then
    if [[ "$LINK_LOCAL" == true ]]; then
        echo "==> Installing symlink to local mimo: $TARGET_BIN -> $SCRIPT_DIR/mimo"
        ln -sf "$SCRIPT_DIR/mimo" "$TARGET_BIN"
    else
        echo "==> Installing local mimo to $TARGET_BIN..."
        install -m 755 "$SCRIPT_DIR/mimo" "$TARGET_BIN"
    fi
else
    echo "==> Downloading mimo from $MIMO_URL..."
    if ! command -v curl >/dev/null 2>&1; then
        echo "Error: 'curl' is required to download mimo." >&2
        exit 1
    fi

    TMP_FILE="$(mktemp -t mimo-install.XXXXXX)"
    cleanup() {
        rm -f "$TMP_FILE"
    }
    trap cleanup EXIT INT TERM

    curl -fsSL -o "$TMP_FILE" "$MIMO_URL"
    chmod +x "$TMP_FILE"
    mv "$TMP_FILE" "$TARGET_BIN"
    echo "==> Installed mimo to $TARGET_BIN"
fi

# Ensure backwards-compatible alias exists
ln -sf "mimo" "$ALIAS_BIN"
echo "==> Created alias: $ALIAS_BIN -> mimo"

# Check PATH
case ":$PATH:" in
    *":$TARGET_DIR:"*)
        echo "==> '$TARGET_DIR' is in your PATH."
        ;;
    *)
        echo ""
        echo "Notice: '$TARGET_DIR' is not in your current PATH."
        echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
        echo "    export PATH=\"$TARGET_DIR:\$PATH\""
        ;;
esac

echo ""
echo "Installation complete! Try running:"
echo "    mimo --help"
