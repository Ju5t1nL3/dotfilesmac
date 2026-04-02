return {
	"chomosuke/typst-preview.nvim",
	lazy = false, -- Or ft = 'typst' to only load on typst files
	version = "1.*",
	build = function()
		require("typst-preview").update()
	end,
	keys = {
		-- Map this to whatever you like to launch the browser preview
		{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
	},
}
