-- This file is part of the VSCode Neovim Plugin configuration.

local vscode = require("vscode")
local map = vim.keymap.set

vim.g.mapleader = " "
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- disable default highlight, we'll manage it manually
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250
vim.opt.grepprg = "rg --vimgrep"
vim.opt.indentexpr = "" -- fix indent issue when pressing `o` in normal mode

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("vscode_highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "YankHighlight",
      on_macro = false,
    })
  end,
})

-- Define yank highlight group
vim.api.nvim_set_hl(0, "YankHighlight", { fg = "#e6e9ef", bg = "#fe640b" })

-- use vscode's notify function
vim.notify = vscode.notify

-- flash.nvim color theme
vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#6e738d" })
vim.api.nvim_set_hl(0, "FlashLabel", { fg =  "#a6da95", bg = "none", bold = true })
vim.api.nvim_set_hl(0, "FlashMatch", { fg =  "#b7bdf8", bg = "none" })
vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#f5a97f", bg = "none" })

-- keymaps
map("n", "<ENTER>", "o<ESC>", { noremap = true, silent = true })
map("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "No highlight search" })
map({ "n", "v", "o" }, "H", "0", {})
map({ "n", "v", "o" }, "L", "$", {})

-- remap Ctrl keys for vscode
map("n", "<leader>v", "<C-v>")
map("n", "<leader>u", "<C-u>")
map("n", "<leader>d", "<C-d>")
map("n", "<leader>f", "<C-f>")
map("n", "<leader>b", "<C-b>")

-- clipboard operations
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

map("n", "<leader>rn", function()
  vscode.call("editor.action.rename")
end)
map({ "n", "i" }, "<leader>o", function()
  vscode.call("workbench.action.navigateBack")
end)
map({ "n", "i" }, "<leader>i", function()
  vscode.call("workbench.action.navigateForward")
end)

map({ "n", "x", "i" }, "<C-d>", function()
  vscode.with_insert(function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
  end)
end)

-- plugins
return {
  require("plugins.flash"),
  -- require("plugins.theme"),
  require("plugins.nvim-surround"),
  require("plugins.treesitter"),
}
