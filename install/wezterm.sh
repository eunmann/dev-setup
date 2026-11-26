#!/usr/bin/env bash
# Install WezTerm from the official apt repo's nightly channel.
#
# Why nightly: the last stable release (20240203) has an X11 IME bug. While the
# window is focused, every text-cursor move re-opens an XIM connection to ibus
# and leaks an unmapped 1x1 window on both sides. Busy TUIs (Claude Code) leak
# thousands per hour, which slows the whole desktop (the compositor tracks every
# window) and freezes it for about a minute when WezTerm closes. Fixed upstream
# in xcb-imdkit-rs (May 2025); only nightly builds include the fix.
#
# The package is put on hold so a routine `apt upgrade` doesn't swap in a new
# nightly every day. Run `install/wezterm.sh --update` to move to the latest.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

PKG="wezterm-nightly"
UPDATE=false
if [[ "${1:-}" == "--update" ]]; then
  UPDATE=true
fi

if need_sudo; then
  SUDO="sudo"
else
  SUDO=""
fi

# Prints the installed version of a package, or nothing if it isn't installed
# (removed-but-not-purged packages still have a dpkg record, so check Status).
installed_version() {
  dpkg-query -W -f='${Status} ${Version}' "$1" 2>/dev/null | awk '$3 == "installed" { print $4 }'
}

echo "==> Installing WezTerm nightly (apt)..."

CURRENT="$(installed_version "$PKG")"
if [[ -n "$CURRENT" && "$UPDATE" == false ]]; then
  echo "    WezTerm nightly already installed ($CURRENT, held)"
  echo "    To update to the latest nightly, run: $0 --update"
  exit 0
fi

echo "    Adding WezTerm apt repository..."
curl -fsSL https://apt.fury.io/wez/gpg.key | $SUDO gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | $SUDO tee /etc/apt/sources.list.d/wezterm.list >/dev/null
$SUDO chmod 644 /usr/share/keyrings/wezterm-fury.gpg
$SUDO apt update -y

if [[ -n "$(installed_version wezterm)" ]]; then
  echo "    Replacing stable wezterm package (it conflicts with $PKG)..."
fi

# The hold blocks `apt install` of a newer version, so lift it for the install.
$SUDO apt-mark unhold "$PKG" >/dev/null 2>&1 || true
$SUDO apt install -y "$PKG"
$SUDO apt-mark hold "$PKG" >/dev/null

echo "    WezTerm installed: $(wezterm --version 2>/dev/null || echo 'unknown') (held)"
