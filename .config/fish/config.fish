if status is-interactive

	# initialize zoxide
	zoxide init fish | source

	# initialize rust
	if test -f "$HOME/.cargo/env.fish"
		source "$HOME/.cargo/env.fish"
	end

	# initialize starship with transient prompt
	function starship_transient_prompt_func
		starship  module directory
		starship  module time
		starship module character
	end
	starship init fish | source
	enable_transience
end
