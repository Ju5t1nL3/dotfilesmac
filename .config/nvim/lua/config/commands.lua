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
		-- Clear the command line before printing
		vim.cmd('echo ""')
		-- Print the capabilities
		print(vim.inspect(clients[client_idx].server_capabilities))
	end
end, {})
