-- Setup nvim-cmp.
return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		"windwp/nvim-autopairs",
	},
	opts = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		return {
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			-- Key mapping
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			-- Snippets sources
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "cmdline" },
			}),

			window = {
				--completion = cmp.config.window.bordered(),
				--documentation = cmp.config.window.bordered(),
			},
			-- Show devicons as kind
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 100,
					ellipsis_char = "...",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
					},
				}),
			},
			view = {
				entries = { name = "custom", selection_order = "near_cursor" },
			},
			-- autocompletion pairs
			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()),

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			}),

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			}),
		}
	end,
}
