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
map("n", "<A-F>", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "<leader>x", function()
  local buffer_id = vim.fn.bufnr()
  vim.cmd "BufferLineCyclePrev"
  vim.cmd("bdelete " .. buffer_id)
end, { desc = "Close current buffer and go to previous" })

map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<C-a>", "ggVG", { desc = "Select all", silent = true })

-- render markdown
map({ "n" }, "<leader>m", ":RenderMarkdown toggle<cr>", { desc = "Render markdown", silent = true })
map({ "n", "i", "v" }, "<C-/>", "<cmd>normal gcc<cr>", { desc = "toggle comment", silent = true })
map("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "vsplit", silent = true })

map('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Goto prev diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true , desc = "Goto next diagnostic" })
map('n', '<C-m>', vim.diagnostic.setloclist, { noremap = true, silent = true , desc = "Diagnostic list" })
