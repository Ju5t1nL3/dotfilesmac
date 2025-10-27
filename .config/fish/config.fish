if status is-interactive
    # Commands to run in interactive sessions can go here
	zoxide init fish | source

	function starship_transient_prompt_func
		starship  module directory
		starship  module time
		starship module character
	end
	starship init fish | source
	enable_transience
end
