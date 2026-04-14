return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			relculright = true,
			segments = {
				-- Git signs, breakpoints, diagnostics
				{ text = { "%s" }, click = "v:lua.ScSa" },
				-- Line numbers
				{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
				-- Folds: This intercepts Neovim's native numbers and replaces them with clean icons
				{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
			},
		})
	end,
}
