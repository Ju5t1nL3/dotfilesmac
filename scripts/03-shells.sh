#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck source=lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/lib.sh"

log "Shells"

setup_brew_env || die "Homebrew is required before shell setup."
has git || die "git is required before shell plugin setup."

if ! has starship; then
  info "Installing Starship prompt"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  info "Starship already installed"
fi

ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

if [[ ! -d "$ZSH_DIR" ]]; then
  info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  info "Oh My Zsh already installed"
fi

clone_if_missing "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
clone_if_missing "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
clone_if_missing "https://github.com/MichaelAquilina/zsh-you-should-use.git" "$ZSH_CUSTOM_DIR/plugins/you-should-use"
clone_if_missing "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
clone_if_missing "https://github.com/Aloxaf/fzf-tab.git" "$ZSH_CUSTOM_DIR/plugins/fzf-tab"

has fish || die "fish is not installed. Rerun scripts/01-brew.sh first."

fish_path="$(command -v fish)"
if ! grep -qx "$fish_path" /etc/shells; then
  read -r -p "Add $fish_path to /etc/shells? [y/N] " reply
  if [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
  else
    warn "$fish_path is not in /etc/shells; chsh may reject it."
  fi
fi

if [[ "${SHELL:-}" != "$fish_path" ]]; then
  read -r -p "Set Fish as your login shell? [y/N] " reply
  if [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    chsh -s "$fish_path"
  else
    info "Leaving login shell unchanged."
  fi
fi
