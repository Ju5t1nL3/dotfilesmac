#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck source=lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/lib.sh"

log "Runtime tools and editor plugins"

setup_brew_env || die "Homebrew is required before tool setup."
has mise || die "mise is not installed. Rerun scripts/01-brew.sh first."
has git || die "git is required before tmux plugin setup."
has tmux || die "tmux is not installed. Rerun scripts/01-brew.sh first."
has bat || die "bat is not installed. Rerun scripts/01-brew.sh first."
has nvim || die "neovim is not installed. Rerun scripts/01-brew.sh first."

info "Installing mise tools from ~/.config/mise/config.toml"
mise install -y
mise reshim

clone_if_missing "https://github.com/tmux-plugins/tpm.git" "$HOME/.config/tmux/plugins/tpm"
clone_if_missing "https://github.com/catppuccin/tmux.git" "$HOME/.config/tmux/plugins/catppuccin/tmux"
if [[ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]]; then
  tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.config/tmux/plugins/"
  "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
fi

bat cache --build

info "Restoring Neovim plugins from lazy-lock.json"
nvim --headless "+Lazy! restore" +qa
