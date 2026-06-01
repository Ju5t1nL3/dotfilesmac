#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck source=lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/lib.sh"

log "GNU Stow"

setup_brew_env || die "Homebrew is required before stowing dotfiles."
has stow || die "stow is not installed. Rerun scripts/01-brew.sh first."

cd "$DOTFILES_DIR"

mkdir -p "$HOME/.config"

info "Checking for symlink conflicts"
stow -n -v . -t "$HOME"

info "Applying symlinks"
stow -v . -t "$HOME"
