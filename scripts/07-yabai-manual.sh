#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'

==> Manual macOS and yabai checklist

1. Open System Settings > Privacy & Security > Accessibility.
   Enable yabai and skhd when macOS prompts for them.

2. For full yabai behavior, partially disable SIP in macOS Recovery.
   This is required for yabai's scripting addition, including space movement.

   In macOS Recovery on Apple Silicon, macOS 13 or newer:
     csrutil enable --without fs --without debug --without nvram

   Reboot after changing SIP.

3. After rebooting into macOS, run this in a regular terminal, not Recovery
   and not tmux, then reboot again:
     sudo nvram boot-args=-arm64e_preview_abi

4. After rebooting into macOS again, configure passwordless loading for yabai's
   scripting addition from a regular terminal:
     echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 "$(which yabai)" | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai

   Repeat this sudoers command after every yabai upgrade because the binary hash changes.

5. Start yabai after the sudoers step from a regular terminal:
     sudo yabai --load-sa
     yabai --start-service

Reference:
  https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
  https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection

EOF
