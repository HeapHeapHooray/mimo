# mimo (Minecraft Mod Manager CLI)

A command-line wrapper for [Minecraft Mod Manager (`mmm`)](https://github.com/meza/minecraft-mod-manager) that anchors all operations to your Minecraft directory (`~/.minecraft`).

This ensures that commands like `list`, `add`, `update`, `install`, and `remove` always manage the exact same `modlist.json` without needing to change directories.

---

## Features

- **Always Anchored**: Executes all `mmm` operations inside `~/.minecraft` regardless of your current terminal working directory.
- **Automated Setup (`mimo init`)**:
  - Automatically detects the active Minecraft version (e.g. `26.2`, `1.21.11`) and mod loader (`fabric`, `quilt`, `forge`, `neoforge`) from Minecraft logs or version metadata.
  - Automatically initializes `modlist.json` with sensible defaults.
  - Automatically scans existing `.jar` mods in `./mods` via Modrinth/CurseForge and adds them to configuration.
  - Supports CLI flags to customize version, loader, release types, and platforms.
- **Transparent Command Forwarding**: Passes all standard `mmm` commands (`list`, `add`, `update`, `install`, `scan`, `prune`, `remove`, `change`) directly to the underlying `mmm` binary.

---

## Requirements

- **Linux** (x86_64)
- **`mmm` binary**: Installed at `~/.minecraft/mmm` or available in `PATH`.

---

## Installation

### One-line Install (Standalone)

```bash
curl -fsSL https://raw.githubusercontent.com/HeapHeapHooray/mimo/refs/heads/main/install.sh | bash
```

### From Source

```bash
git clone https://github.com/HeapHeapHooray/mimo.git
cd mimo
./install.sh
```

This installs `mimo` and the `minecraft-mods` alias into `~/.local/bin`.

---

## Usage

### 1. Initialize & Configure

Automatically detect the game version, loader, create `modlist.json`, and scan existing mods:

```bash
mimo init
```

Override detection or customize options:

```bash
mimo init --game-version 26.2 --loader fabric --prefer modrinth --force
```

#### Init Options:
- `-g, --game-version <VER>`: Minecraft version (e.g. `26.2`). Auto-detected if omitted.
- `-l, --loader <LOADER>`: Mod loader (`fabric`, `forge`, `neoforge`, `quilt`). Auto-detected if omitted.
- `-r, --release-types <TYPES>`: Allowed release types (default: `release,beta`).
- `-m, --mods-folder <PATH>`: Relative or absolute path to mods directory (default: `./mods`).
- `-p, --prefer <PLATFORM>`: Preferred platform for mod scanning: `modrinth` or `curseforge` (default: `modrinth`).
- `--no-scan`: Skip scanning existing `.jar` files.
- `-f, --force`: Overwrite existing `modlist.json` without prompting.
- `-h, --help`: Display init options.

---

### 2. Manage Mods

From any directory:

```bash
# List configured and installed mods
mimo list

# Add a mod
mimo add modrinth sodium
mimo add modrinth iris

# Check and download updates for managed mods
mimo update

# Install all mods from modlist.json
mimo install

# Remove a mod
mimo remove sodium

# Scan mods directory for unmanaged mods
mimo scan -a

# View help
mimo --help
```
