#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd -P)"

log() {
  printf '\n==> %s\n' "$*"
}

info() {
  printf '    %s\n' "$*"
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

has() {
  command -v "$1" >/dev/null 2>&1
}

ensure_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || die "This installer only supports macOS."
  [[ "$(uname -m)" == "arm64" ]] || die "This installer is intended for Apple Silicon Macs only."
}

brew_bin() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    printf '/opt/homebrew/bin/brew\n'
  else
    return 1
  fi
}

setup_brew_env() {
  local brew
  brew="$(brew_bin)" || return 1
  eval "$(SHELL=/bin/bash "$brew" shellenv)"
}

clone_if_missing() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    info "Already present: $dest"
    return
  fi

  if [[ -e "$dest" ]]; then
    die "$dest already exists but is not a Git clone. Inspect it, then delete or rename it before rerunning."
  fi

  mkdir -p "$(dirname "$dest")"
  git clone --depth=1 "$repo" "$dest"
}
