if status is-interactive
	zoxide init fish | source

	# Enable transient prompt
	function starship_transient_prompt_func
		starship  module directory
		starship  module time
		starship module character
	end
	starship init fish | source
	enable_transience
end
