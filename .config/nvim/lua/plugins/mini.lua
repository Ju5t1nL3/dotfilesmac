return { -- Collection of various small independent plugins/modules
	"nvim-mini/mini.nvim",
	keys = {
		{
			-- This is the "smart" command to open the directory of the current file
			"<leader>e",
			function()
				local buf_name = vim.api.nvim_buf_get_name(0)
				local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")

				-- Check if the file exists
				if vim.fn.filereadable(buf_name) == 1 then
					-- If yes, open mini.files highlighting that file
					require("mini.files").open(buf_name, true)
					-- If file doesn't exist, check if its parent directory does
				elseif vim.fn.isdirectory(dir_name) == 1 then
					require("mini.files").open(dir_name, true)
					-- If neither exists, fall back to the current working directory
				else
					require("mini.files").open(vim.uv.cwd(), true)
				end
			end,
			desc = "Open mini.files (smart)",
		},
		{
			"<leader>E",
			function()
				require("mini.files").open(vim.uv.cwd(), true)
			end,
			desc = "Open mini.files (cwd)",
		},
	},
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		-- Mini tree files
		require("mini.files").setup()

        -- Mini auto pairs
        require("mini.pairs").setup()

		-- Simple and easy statusline.
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
