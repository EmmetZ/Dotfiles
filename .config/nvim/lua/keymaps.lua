local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", {})
map("n", "<C-l>", "<C-w>l", {})
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("n", "<ENTER>", "o<ESC>", { noremap = true, silent = true })
map({ "n", "v", "o" }, "H", "0", {})
map({ "n", "v", "o" }, "L", "$", {})

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
map("n", "<C-q>", "<C-w>q", { desc = "close window" })

-- conform
map("n", "<leader>cf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- resize
map("n", "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

map("n", "<leader>X", "<CMD>tabclose<CR>", { desc = " Close current tab" })

map({ "n", "i" }, "<C-s>", "<CMD>w<CR>", { desc = "Save" })
map("n", "<C-a>", "ggVG", { desc = "Select all", silent = true })

-- render markdown
map({ "n" }, "<leader>Tm", "<CMD>RenderMarkdown toggle<CR>", { desc = "Render markdown", silent = true })
map({ "n", "i", "v" }, "<C-/>", "<CMD>normal gcc<CR>", { desc = "toggle comment", silent = true })
map("n", "<C-\\>", "<CMD>vsplit<CR>", { desc = "vsplit", silent = true })

map('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Goto prev diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Goto next diagnostic" })
map('n', '<C-m>', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic list" })

-- typst preview
map('n', '<leader>Tp', "<CMD>TypstPreviewToggle<CR>", { noremap = true, silent = true, desc = "Typst Preview Toggle" })

map('n', '<leader>li', "<CMD>LspInfo<CR>", { noremap = true, silent = true, desc = "Lsp Info" })
