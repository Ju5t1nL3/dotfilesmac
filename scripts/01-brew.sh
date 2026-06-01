#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck source=lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/lib.sh"

ensure_macos

log "Homebrew"

if ! setup_brew_env; then
  info "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_brew_env || die "Homebrew installed, but brew was not found in PATH."
else
  info "Homebrew found: $(brew --prefix)"
fi

brew bundle --file "$DOTFILES_DIR/Brewfile"
