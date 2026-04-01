-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- [[ Load Core Config ]]
require("core.options")
require("core.keymaps")
require("core.autocmds")

vim.api.nvim_create_user_command("LspInspect", function()
	-- Get clients for the CURRENT buffer only (bufnr = 0)
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		print("No active LSP clients for the current buffer.")
		return
	end

	local client_names = {}
	-- Use 'i' (the index) from ipairs to build the string
	for i, client in ipairs(clients) do
		table.insert(client_names, i .. ": " .. client.name)
	end

	local client_idx = vim.fn.inputlist({
		"Select client to inspect:",
		unpack(client_names),
	})

	if client_idx > 0 and client_idx <= #clients then
		-- Clear the command line before printing
		vim.cmd('echo ""')
		-- Print the capabilities
		print(vim.inspect(clients[client_idx].server_capabilities))
	end
end, {})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!

			-- [[ Configure Telescope ]]
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Search All files (hidden, .gitignore, but NOT .git)
			vim.keymap.set("n", "<leader>sa", function()
				builtin.find_files({
					find_command = {
						"fd",
						"--type",
						"f",
						"--hidden",
						"--no-ignore",
						"--exclude",
						".git",
					},
				})
			end, { desc = "[S]earch [A]ll Files (hidden, ignored)" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_format = "fallback",
			-- },
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				haskell = { "fourmolu", "stylish-haskell" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				svg = { "prettierd", "prettier", stop_after_first = true },
				typst = { "typstyle" },
			},
		},
	},

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = "make install_jsregexp",
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"xeluxee/competitest.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		cmd = {
			"CompetiTest",
		},
		opts = {
			-- testcases_directory = "./.tests",
			testcases_use_single_file = true,
			compile_command = {
				c = {
					exec = "gcc",
					args = { "-O2", "-g", "-fno-omit-frame-pointer", "-Wall", "$(FNAME)", "-o", "main" },
				},
				cpp = {
					exec = "g++",
					args = { "-O2", "-g", "-fno-omit-frame-pointer", "-Wall", "$(FNAME)", "-o", "main", "-DLOCAL" },
				},
				rust = { exec = "rustc", args = { "-g", "$(FNAME)" } },
				java = { exec = "javac", args = { "$(FNAME)" } },
				haskell = { exec = "ghc", args = { "$(FNAME)" } },
			},
			run_command = {
				c = { exec = "./main" },
				cpp = { exec = "./main" },
				python = { exec = "python3", args = { "$(FNAME)" } },
			},
			template_file = {
				cpp = "~/Coding/personal/competitive-programming/template.cpp",
				py = "~/Coding/personal/competitive-programming/template.py",
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("catppuccin").setup({
				flavour = "mocha",
				styles = {
					comments = {},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
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
	},
	{ -- Collection of various small independent plugins/modules
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

			-- Simple and easy statusline.
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
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
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},

	-- require 'kickstart.plugins.debug',
	require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),

	-- { import = 'custom.plugins' },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
