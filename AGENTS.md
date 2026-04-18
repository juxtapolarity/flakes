# AGENTS.md — juxcluster

## Overview

NixOS Flake managing system and Home Manager configurations for a 3-machine cluster:
`juxpc`, `juxserver`, `amaliepc`. Uses `nixpkgs` unstable on `x86_64-linux`.

## Build / Validate / Deploy Commands

```bash
# Validate the flake (closest thing to "run tests")
nix flake check

# Build without switching (dry run for a specific host)
nixos-rebuild build --flake .#juxpc
nixos-rebuild build --flake .#juxserver
nixos-rebuild build --flake .#amaliepc

# Deploy to the current machine
sudo nixos-rebuild switch --flake .#<hostname>

# Update flake inputs (nixpkgs, home-manager)
nix flake update

# Evaluate a single file for syntax errors
nix-instantiate --parse <file.nix>
```

There is no test framework. Validation is done via `nix flake check` and
`nixos-rebuild build`. Always run `nix flake check` after making changes.

## Repository Structure

```
juxcluster/
├── flake.nix                            # Entry point: mkHost helper, 3 host defs
├── flake.lock                           # Pinned input versions
├── juxshared.nix                        # Shared Home Manager config (all hosts)
├── juxpc.nix                            # juxpc Home Manager (desktop/gaming)
├── juxserver.nix                        # juxserver Home Manager (server tools)
├── amaliepc.nix                         # amaliepc Home Manager (minimal)
└── nixos/
    ├── configuration.nix                # Shared NixOS config (boot, net, shell)
    ├── configuration-juxpc.nix          # juxpc NixOS (X11/i3, NVIDIA, Steam)
    ├── configuration-juxserver.nix      # juxserver NixOS (SSH, Docker, services)
    ├── configuration-amaliepc.nix       # amaliepc NixOS (X11/GNOME, Tailscale)
    ├── hardware-configuration-juxpc.nix
    ├── hardware-configuration-juxserver.nix
    └── hardware-configuration-amaliepc.nix
```

### Architecture

`flake.nix` defines a `mkHost` helper that composes each host from:
1. Shared NixOS config (`nixos/configuration.nix`)
2. Per-host NixOS config (`nixos/configuration-<host>.nix`)
3. Hardware config (`nixos/hardware-configuration-<host>.nix`)
4. Home Manager with per-host HM config (`<host>.nix` imports `juxshared.nix`)

Users: `jux` on juxpc/juxserver, `amalie` on amaliepc. All use zsh.
Dotfiles are symlinked from `~/.config/dotfiles/` via `mkOutOfStoreSymlink`.

## Code Style Guidelines

### File Naming
- Lowercase, hyphen-separated: `configuration-juxpc.nix`, `hardware-configuration-server.nix`
- Host HM files: `<hostname>.nix` at repo root
- Host NixOS files: `nixos/configuration-<hostname>.nix`

### Function Signatures
- NixOS system configs: `{ config, lib, pkgs, modulesPath, ... }:`
- Home Manager configs: `{ config, pkgs, ... }:` or `{ pkgs, ... }:`
- Shared HM (juxshared): `{ config, pkgs, username, ... }:`
- Always include `...` in the attrset pattern to allow extra args

### Imports
- Use `imports = [ ./juxshared.nix ];` at the top of host HM files
- In `flake.nix`, reference paths with `./nixos/configuration.nix` style

### Formatting and Layout
- 2-space indentation
- Section banners using:
  ```nix
  # ---------------------------------------------------------------------------
  # Section Title
  # ---------------------------------------------------------------------------
  ```
- Group related options under clear section banners
- Use `with pkgs;` inside package list brackets for conciseness:
  ```nix
  home.packages = with pkgs; [
    btop
    git
    vim
  ];
  ```
- Sort package lists alphabetically when practical

### Dotfile Symlinks
Use `mkOutOfStoreSymlink` to link dotfiles from the user's dotfiles dir:
```nix
home.file.".config/foo".source =
  config.lib.file.mkOutOfStoreSymlink
    "/home/${username}/.config/dotfiles/foo";
```
This keeps dotfiles managed outside the Nix store for easy editing.

### Adding a New Host
1. Create `nixos/hardware-configuration-<host>.nix` (from `nixos-generate-config`)
2. Create `nixos/configuration-<host>.nix` with host-specific system config
3. Create `<host>.nix` with Home Manager config (import `./juxshared.nix`)
4. Add a new `mkHost` call in `flake.nix` under `nixosConfigurations`

### Adding Packages
- User-level packages go in the host's HM file (`<host>.nix`) or `juxshared.nix`
- System-level packages/services go in `nixos/configuration-<host>.nix`
- Shared system config goes in `nixos/configuration.nix`
- If a package is needed on all hosts, add it to `juxshared.nix`

### Services
Services (Docker containers, daemons) are configured in
`nixos/configuration-juxserver.nix` using NixOS module options like
`virtualisation.oci-containers.containers.<name>` and `services.<name>`.

## Git Conventions

- Short imperative commit messages, no prefix convention
- Examples: `Add firefox to amaliepc`, `Fix printer name`, `Change hostname`
- Pattern: `Add <thing>`, `Fix <thing>`, `Remove <thing>`, `Change <thing>`

## Common Pitfalls

- **Hardware configs are machine-generated.** Do not edit
  `hardware-configuration-*.nix` files by hand; regenerate with
  `nixos-generate-config` if hardware changes.
- **flake.lock pins versions.** Run `nix flake update` to get latest nixpkgs.
- **Dotfiles live outside this repo** in `~/.config/dotfiles/`. This repo only
  creates symlinks to them.
- **Nix is lazy.** A `nix flake check` may pass even if a host config has
  errors that only surface during `nixos-rebuild build`.
  Build each affected host after changes.
