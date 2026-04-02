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

	-- require 'kickstart.plugins.debug',
	require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),

	-- { import = 'custom.plugins' },
})
