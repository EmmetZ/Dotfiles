-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "" -- disable system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim
vim.o.mousemoveevent = true -- allow the mouse move event

vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = true -- highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

vim.g.mapleader = " "
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250
vim.opt.laststatus = 3

vim.g.ai_cmp = false
