-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("config.lazy")

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copy) tex',
	group = vim.api.nvim_create_augroup('main-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Share system keyboard
vim.opt.clipboard = "unnamedplus"

-- Setup colorscheme
vim.cmd.colorscheme "catppuccin"

-- Relative line numbers
vim.wo.relativenumber = true

-- Set show whitespace
vim.opt.list = true
vim.opt.listchars:append({ space = '·' })

-- Quickfix keymaps
vim.keymap.set("n", "<Q-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<Q-k>", "<cmd>cprev<CR>")

-- Oil keymaps
vim.keymap.set("n", "-", "<cmd>Oil<CR>")
