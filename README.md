# dotfilesmac

macOS dotfiles for shell, terminal, editor, window management, and status bar setup. The bootstrap path is designed for a fresh Apple Silicon Mac after cloning this repository.

## Mac Settings Changes

Adjust these in System Settings before or after running the installer:

- Keyboard > Keyboard Shortcuts > Modifier Keys: rebind Caps Lock to Esc.
- Keyboard > Keyboard Shortcuts > Modifier Keys: swap Control and Command.

## Quick Start

This installer targets Apple Silicon Macs only. Intel Macs are not supported by the bootstrap scripts.

Install Xcode Command Line Tools if macOS has not prompted for them yet:

```sh
xcode-select --install
```

Clone this repository to the expected path and run the installer:

```sh
git clone https://github.com/Ju5t1nL3/dotfilesmac.git ~/dotfilesmac
cd ~/dotfilesmac
bash install.sh
```

Run the installer from a normal terminal session, not inside tmux. Homebrew services cannot be managed from inside tmux.

The installer is safe to rerun. It installs Homebrew if needed, runs `brew bundle`, stows dotfiles into `$HOME`, installs shell tooling, restores runtime tools with `mise`, restores tmux/Neovim plugins, and starts supported services.

## What Still Requires Manual Setup

Ghostty is intentionally not installed through Homebrew. Install it manually from [ghostty.org/download](https://ghostty.org/download), then restart Ghostty so it picks up the stowed config at `~/.config/ghostty`.

Yaak is also intentionally not installed through Homebrew because the app handles its own updates. Install the macOS DMG manually from [yaak.app/download?platform=macos](https://yaak.app/download?platform=macos).

macOS privacy and recovery-mode settings cannot be fully automated. After the script runs, open System Settings > Privacy & Security > Accessibility and enable `yabai` and `skhd` if prompted.

Full yabai space control also requires the scripting addition. Current yabai docs require partially disabling SIP in Recovery, then configuring a sudoers entry for `sudo yabai --load-sa`. The installer prints the exact commands in `scripts/07-yabai-manual.sh`.

Useful manual follow-ups:

```sh
gh auth login
gh extension install github/gh-copilot
zsh -ic 'p10k configure'
```

## Installer Layout

- `install.sh`: master bootstrap entrypoint.
- `scripts/01-brew.sh`: Homebrew and `Brewfile`.
- `scripts/02-stow.sh`: dry-run and apply GNU Stow links.
- `scripts/03-shells.sh`: Starship, Oh My Zsh, Zsh plugins, and Fish login-shell setup.
- `scripts/04-tools.sh`: `mise`, tmux TPM, Bat cache, and Neovim plugin restore.
- `scripts/05-services.sh`: `skhd`, `sketchybar`, and conditional `yabai` service setup.
- `scripts/06-manual-apps.sh`: manual app reminders, including Ghostty and Yaak.
- `scripts/07-yabai-manual.sh`: manual SIP and scripting-addition checklist.

## Troubleshooting

Preview dotfile links without changing anything:

```sh
stow -n -v . -t ~
```

Check Homebrew dependencies:

```sh
brew bundle check --file Brewfile
```

Restart services after changing configs:

```sh
skhd --restart-service
yabai --restart-service
brew services restart sketchybar
```

After upgrading yabai, rerun the sudoers command printed by `scripts/07-yabai-manual.sh`, then run:

```sh
sudo yabai --load-sa
yabai --restart-service
```
