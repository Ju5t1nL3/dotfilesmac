if status is-interactive
	# Abbreviations

	# Git abbreviations
	abbr -a lg lazygit

	abbr -a g git
	abbr -a ga git add
	abbr -a gaa git add --all
	abbr -a gb git branch
	abbr -a gbD git branch --delete --force
	abbr -a gco git checkout
	abbr -a gcb git checkout -B
	abbr -a gc git commit --verbose
	abbr -a gca git commit --verbose --all
	abbr -a gd git diff
	abbr -a gf git fetch
	abbr -a glog git log --decorate --graph
	abbr -a gl git pull
	abbr -a gp git push
	abbr -a gpsup git push --set-upstream origin
	abbr -a gst git status

	abbr -a l eza --icons --group-directories-first
	abbr -a la eza --icons --group-directories-first -a
	abbr -a nv nvim
	abbr -a tm tmux

	abbr -a bdump brew bundle dump --brews --casks --taps --force --file=~/dotfilesmac/Brewfile

	# Config abbreviations
	abbr -a fishconfig nvim ~/dotfilesmac/.config/fish/config.fish
	abbr -a skhdconfig nvim ~/dotfilesmac/.config/skhd/skhdrc
	abbr -a yabaiconfig nvim ~/dotfilesmac/.config/yabai/yabairc
	abbr -a ghosttyconfig nvim ~/dotfilesmac/.config/ghostty/config
	abbr -a sketchybarconfig nvim ~/dotfilesmac/.config/sketchybar/sketchybarrc
	abbr -a tmuxconfig nvim ~/dotfilesmac/.config/tmux/tmux.conf

	abbr -a fishrestart exec fish
	abbr -a fixyabai "killall yabai skhd; yabai --start-service; skhd --start-service"

	abbr -a codex-misc codex -C /tmp/codex-misc -s read-only
end
