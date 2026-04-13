return { -- Highlight, edit, and navigate code
	"romus204/tree-sitter-manager.nvim",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"python",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"typst",
		},
		auto_install = true,
	},
}
