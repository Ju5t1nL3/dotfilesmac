# GHCup (Haskell) configuration
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME

# Use fish_add_path instead of manual PATH manipulation
# This is safer and prevents duplicate entries
fish_add_path $HOME/.cabal/bin
fish_add_path /Users/justinle/.ghcup/bin
