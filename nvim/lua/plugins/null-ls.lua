return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local lsp_formatting = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local nls = require("null-ls")
		nls.setup({
			sources = {
				nls.builtins.formatting.stylua,
				nls.builtins.formatting.eslint,
				nls.builtins.diagnostics.eslint,
				nls.builtins.completion.luasnip,
				nls.builtins.code_actions.eslint_d,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							lsp_formatting(bufnr)
						end,
					})
				end
			end,
		})
	end,
}