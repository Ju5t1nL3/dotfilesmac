#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'

==> Manual app checklist

Ghostty is not installed by Homebrew in this setup, so the app can manage its
own updates.

If Ghostty is missing, install it manually:
  https://ghostty.org/download

Your Ghostty config has already been linked to:
  ~/.config/ghostty

After installing Ghostty, restart the app so it picks up the stowed config.

Yaak is not installed by Homebrew in this setup, so the app can manage its own
updates.

If Yaak is missing, install the macOS DMG manually:
  https://yaak.app/download?platform=macos

EOF
