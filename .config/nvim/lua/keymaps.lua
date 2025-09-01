local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", {})
map("n", "<C-l>", "<C-w>l", {})
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("i", "jj", "<ESC>", { noremap = true, silent = true })
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

-- resize
map("n", "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

map("n", "<leader>X", "<CMD>tabclose<CR>", { desc = " Close current tab" })

map({ "n", "i" }, "<C-s>", "<CMD>w<CR>", { desc = "Save" })
map("n", "<C-a>", "ggVG", { desc = "Select all", silent = true })

map({ "n", "i", "v" }, "<C-/>", "<CMD>normal gcc<CR>", { desc = "toggle comment", silent = true })
map({ "n", "i" }, "<C-\\>", "<CMD>vsplit<CR>", { desc = "vsplit", silent = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local goto_next = function (opt)
    opt = opt or {}
    opt.count = 1
    vim.diagnostic.jump(opt)
  end
  local goto_prev = function (opt)
    opt = opt or {}
    opt.count = -1
    vim.diagnostic.jump(opt)
  end
  local go = next and goto_next or goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "]d", diagnostic_goto(true), { desc = "Goto next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Goto prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Goto next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Goto prev Error" })
map("n", "gm", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Open float diagnostic info" })
-- map('n', '<C-m>', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic list" })

map("n", "<leader>li", "<CMD>LspInfo<CR>", { noremap = true, silent = true, desc = "LSP Info" })
map("n", "<leader>lr", function()
  -- restart LSP server
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("No LSP client found")
    return
  end
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
    vim.lsp.start(client.config)
    vim.notify(client.name .. " restarted", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = "Restart LSP" })

vim.keymap.del("n", "<C-w><C-d>")

map("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "No highlight search" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
