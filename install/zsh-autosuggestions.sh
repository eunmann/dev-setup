#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

get_user_info

echo "==> Installing zsh-autosuggestions..."

PLUGIN_DIR="$USER_HOME/.zsh/zsh-autosuggestions"
REPO_URL="https://github.com/zsh-users/zsh-autosuggestions.git"

# Run a command as the real user (handles running under sudo)
as_user() {
  if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    sudo -u "$USER_NAME" -- "$@"
  else
    "$@"
  fi
}

# Already cloned from the same repo — just update it
if [ -d "$PLUGIN_DIR/.git" ]; then
  REMOTE="$(git -C "$PLUGIN_DIR" remote get-url origin 2>/dev/null || echo "")"
  if [[ "$REMOTE" == *"zsh-users/zsh-autosuggestions"* ]]; then
    echo "    Already installed, pulling latest..."
    if as_user git -C "$PLUGIN_DIR" pull --ff-only 2>/dev/null; then
      echo "    zsh-autosuggestions up to date"
    else
      echo "    WARNING: git pull failed — local changes or upstream divergence"
      echo "    To update manually: rm -rf $PLUGIN_DIR && $SCRIPT_DIR/$(basename "$0")"
    fi
    exit 0
  fi
fi

# Back up anything else living at that path
if [ -e "$PLUGIN_DIR" ]; then
  BACKUP="$PLUGIN_DIR.bak.$(date +%Y%m%d-%H%M%S)"
  echo "    Backing up existing $PLUGIN_DIR to $BACKUP"
  mv "$PLUGIN_DIR" "$BACKUP"
fi

as_user mkdir -p "$USER_HOME/.zsh"

echo "    Cloning zsh-users/zsh-autosuggestions to $PLUGIN_DIR..."
as_user git clone --depth 1 "$REPO_URL" "$PLUGIN_DIR"

echo "    zsh-autosuggestions installed"
echo "    Sourced by .zshrc — accept a suggestion with → (right arrow) or End"
