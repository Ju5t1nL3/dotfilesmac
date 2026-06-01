#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

# shellcheck source=scripts/lib.sh
source "$REPO_DIR/scripts/lib.sh"

ensure_macos

log "dotfilesmac installer"
info "Repository: $REPO_DIR"

if [[ "$REPO_DIR" != "$HOME/dotfilesmac" ]]; then
  warn "This repo is expected at $HOME/dotfilesmac. Some editor aliases point there."
fi

if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
  die "Finish the Command Line Tools installer, then rerun: bash install.sh"
fi

steps=(
  "scripts/01-brew.sh"
  "scripts/02-stow.sh"
  "scripts/03-shells.sh"
  "scripts/04-tools.sh"
  "scripts/05-services.sh"
  "scripts/06-manual-apps.sh"
  "scripts/07-yabai-manual.sh"
)

for step in "${steps[@]}"; do
  bash "$REPO_DIR/$step"
done

log "Bootstrap complete"
info "Finish any manual macOS permissions and yabai SIP steps printed above."
info "Restart your terminal after shell, font, and service changes."
