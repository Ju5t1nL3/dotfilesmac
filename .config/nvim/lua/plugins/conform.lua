return { -- Autoformat
	"stevearc/conform.nvim",
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
	opts = function()
		local function has_config(ctx, names)
			return vim.fs.find(names, {
				path = ctx.filename,
				upward = true,
			})[1] ~= nil
		end

		local function has_biome(ctx)
			return has_config(ctx, { "biome.json", "biome.jsonc" })
		end

		local function has_prettier(ctx)
			return has_config(ctx, {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.json5",
				".prettierrc.yaml",
				".prettierrc.yml",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
				"prettier.config.ts",
				"prettier.config.mts",
				"prettier.config.cts",
			})
		end

		return {
			notify_on_error = false,
			formatters = {
				biome = {
					condition = has_biome,
				},
				prettier = {
					condition = has_prettier,
				},
				prettierd = {
					condition = has_prettier,
				},
			},
			formatters_by_ft = {
				astro = { "biome", "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				haskell = { "fourmolu", stop_after_first = true },
				javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				css = { "biome", "prettierd", "prettier", stop_after_first = true },
				svg = { "prettierd", "prettier", stop_after_first = true },
				typst = { "typstyle" },
			},
		}
	end,
}
