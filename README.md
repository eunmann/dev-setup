# dev-setup

Personal development environment setup for Debian/Ubuntu: WezTerm + Zsh dotfiles plus a modular installer for Go, Neovim, Claude Code, Node, and Docker.

## Quick Start

**Complete installation (recommended):**
```bash
./install-all.sh
```

This installs everything:
- WezTerm nightly (apt) + SauceCodePro Nerd Font
- Zsh as default shell + zsh-autosuggestions + custom configurations
- Go (latest from go.dev)
- Neovim (latest from GitHub) + kickstart.nvim config
- Claude Code (native binary)
- NVM + Node LTS
- Docker

**Or install components separately:**

Terminal setup only:
```bash
./install.sh
```

Development tools only (Go + Neovim + kickstart.nvim + Claude Code + NVM/Node):
```bash
./install-devtools.sh
```

Docker only:
```bash
./install/docker.sh
```

## Modular Installation

**Terminal setup modules:**
```bash
./install/packages.sh          # Install apt packages
./install/wezterm.sh           # Install WezTerm nightly (--update for the latest build)
./install/fonts.sh             # Install Nerd Fonts
./install/zsh-setup.sh         # Set zsh as default shell
./install/zsh-autosuggestions.sh  # Clone zsh-autosuggestions to ~/.zsh
./install/dotfiles.sh          # Copy config files to ~
./install/zshrc.sh             # Install/update only .zshrc (with backup)
```

**Development tools modules:**
```bash
./install/go.sh                # Install latest Go from go.dev
./install/neovim.sh            # Install latest Neovim from GitHub
./install/nvim-config.sh       # Clone kickstart.nvim to ~/.config/nvim
./install/claude-code.sh       # Install Claude Code native binary
./install/nvm.sh               # Install NVM + latest LTS Node
./install/devstart.sh          # Install devstart (nvim + claude split launcher)
```

**Container platform:**
```bash
./install/docker.sh            # Install Docker and add user to docker group
```

## Features

**WezTerm:**
- Nightly build, held in apt. The last stable release (2024) leaks X11 windows through ibus while a busy TUI like Claude Code runs, slowing the desktop and freezing it when WezTerm closes. Update with `./install/wezterm.sh --update`
- Tokyo Night color scheme
- SauceCodePro Nerd Font
- SUPER+hjkl pane navigation, SUPER+| / SUPER+_ splitting
- Git repository/branch display in right status bar

**Zsh:**
- Shared history across sessions
- Autosuggestions from history (accept with → , End or Ctrl+Space)
- Git branch integration with WezTerm
- Minimal prompt (git info shown in terminal status bar)

**Dev workflow:**
- `devstart` — opens nvim + claude in a WezTerm split

## Verification

Run `./check.sh` to verify the environment is set up correctly and check for available updates. It's read-only and never installs anything.

## Configuration Files

- `.wezterm.lua` - WezTerm configuration
- `.zshrc` - Zsh configuration

Edit these files in the repository, then run `./install/dotfiles.sh` to copy them to your home directory. Existing files are automatically backed up with timestamps.
