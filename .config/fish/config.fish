if status is-interactive

	# initialize zoxide
	zoxide init fish | source

	# initialize rust
	source "$HOME/.cargo/env.fish"

	# initialize direnv
	direnv hook fish | source

	# initialize starship with transient prompt
	function starship_transient_prompt_func
		starship  module directory
		starship  module time
		starship module character
	end
	starship init fish | source
	enable_transience
end
