vim.api.nvim_create_user_command("Lsp", function()
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
		local client = clients[client_idx]
		-- This finds the absolute path of the command Neovim is running
		local exec_path = vim.fn.exepath(client.config.cmd[1])

		-- Clear the command line before printing
		vim.cmd('echo ""')
		print("------------------------------------------")
		print(" LSP Name: " .. client.name)
		print(" Binary:   " .. exec_path)
		print("------------------------------------------")

		-- Print the capabilities
		print(vim.inspect(clients[client_idx].server_capabilities))
	end
end, {})
