# Repository Guidelines

## Agent Workflow Rules

- Never commit changes.
- Never push changes.
- Never create branches unless explicitly asked.
- Always show diffs before major refactors.
- Prefer minimal, surgical edits.
- Ask before destructive operations.

## Project Structure & Module Organization

This repository contains macOS dotfiles intended to be linked into `$HOME` with GNU Stow. Top-level dotfiles such as `.zshrc` and `.gitconfig` live at the repository root. Application configs live under `.config/`, including `fish`, `nvim`, `tmux`, `ghostty`, `sketchybar`, `skhd`, `yabai`, `bat`, `lazygit`, and `mise`. `Brewfile` declares Homebrew taps, formulae, and casks. `wallpapers/` stores image assets and attribution notes for my mac wallpaper, while `docs/` contains general project documentation. `.stow-local-ignore` excludes docs, Git metadata, and Homebrew metadata from symlink installation.

## Build, Test, and Development Commands

Run commands from the repository root.

- `brew bundle check --file Brewfile`: verify Homebrew dependencies are installed.
- `brew bundle --file Brewfile`: install missing Homebrew dependencies.
- `stow -n -v . -t ~`: dry-run dotfile symlink changes before applying them.
- `stow -v . -t ~`: link tracked dotfiles into the home directory.
- `zsh -n .zshrc`: check Zsh syntax after editing shell startup config.
- `fish -n .config/fish/config.fish`: check Fish syntax after editing Fish config.

## Coding Style & Naming Conventions

Keep configuration files small, readable, and grouped by tool. Preserve existing indentation: two spaces in YAML/TOML where already used, shell-style indentation in `.fish`, `.sh`, and `.zsh` files, and Lua conventions in `.config/nvim/`. Use lowercase, descriptive filenames for scripts and config fragments, such as `.config/sketchybar/plugins/front_app.sh`. Avoid unrelated formatting churn in generated or tool-managed files such as `.config/fish/fish_variables` and `.config/nvim/lazy-lock.json`.

## Testing Guidelines

There is no centralized test suite. Validate changes with the narrowest relevant checks: Stow dry-runs for symlink layout, shell syntax checks for shell edits, and application startup checks when touching interactive tools. For example, after changing Neovim config, open Neovim locally or run a headless startup check if plugins are already installed.

## Commit & Pull Request Guidelines

Recent commits use short imperative subjects, usually capitalized, such as `Add gcp` or `Change name for commits`. Follow that style and keep each commit focused on one tool or behavior. Pull requests should describe the changed config, list manual validation performed, and include screenshots only for visible UI changes such as SketchyBar, terminal, or wallpaper updates.

## Security & Configuration Tips

Do not commit secrets, machine-specific tokens, private hostnames, or local credentials. Prefer environment variables, `direnv`, or untracked local files for sensitive settings. Review `Brewfile` additions carefully because they install software on contributor machines.
