--Load dependences

-- core
require("core.options")
require("core.keymaps")

-- Load the plugin manager, Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	install = { colorscheme = { "tokyonight-night" } },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
})
