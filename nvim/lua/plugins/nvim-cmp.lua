-- Setup nvim-cmp.
return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lua",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {
			check_ts = true,
		} },
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			-- Key mapping
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
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

			-- window = {
			-- 	--completion = cmp.config.window.bordered(),
			-- 	--documentation = cmp.config.window.bordered(),
			-- },

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
		})
	end,
}
