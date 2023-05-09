return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"jay-babu/mason-nvim-dap.nvim",
	},
	keys = {
		{
			"<leader>du",
			function()
				require("dapui").toggle({})
			end,
			noremap = true,
			desc = "Dap UI",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_setup = true,
			ensure_installed = {
				"cpptools",
			},
			handlers = {},
		})

		--Basic debugging keymaps
		vim.keymap.set("n", "<F5>", dap.continue)
		vim.keymap.set("n", "<F1>", dap.step_into)
		vim.keymap.set("n", "<F2>", dap.step_over)
		vim.keymap.set("n", "<F3>", dap.step_out)
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
