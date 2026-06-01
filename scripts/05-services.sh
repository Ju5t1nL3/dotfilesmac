#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# shellcheck source=lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/lib.sh"

log "macOS services"

setup_brew_env || die "Homebrew is required before service setup."
has skhd || die "skhd is not installed. Rerun scripts/01-brew.sh first."
has sketchybar || die "sketchybar is not installed. Rerun scripts/01-brew.sh first."
has yabai || die "yabai is not installed. Rerun scripts/01-brew.sh first."

if [[ -n "${TMUX:-}" ]]; then
  die "brew services cannot run inside tmux. Open a normal terminal and rerun this script."
fi

restart_or_start() {
  local service_bin="$1"

  if "$service_bin" --restart-service >/dev/null 2>&1; then
    info "Restarted $service_bin"
  else
    "$service_bin" --start-service
  fi
}

restart_or_start skhd

brew services restart sketchybar

if [[ -f /private/etc/sudoers.d/yabai ]]; then
  restart_or_start yabai
else
  warn "Skipping yabai service start until the scripting-addition sudoers step is complete."
fi
