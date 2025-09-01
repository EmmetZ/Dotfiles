-- Hint: use `:h <option>` to figure out the meaning if needed
-- vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.clipboard = ''      -- disable system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.mouse = 'a'         -- allow the mouse to be used in Nvim
vim.o.mousemoveevent = true -- allow the mouse move event

-- Tab
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of spacesin tab when editing
vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true         -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true     -- open new vertical split bottom
vim.opt.splitright = true     -- open new horizontal splits right
vim.opt.termguicolors = true  -- enabl 24-bit RGB color in the TUI
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.o.pumheight = 12

-- Searching
vim.opt.incsearch = true  -- search as characters are entered
vim.opt.hlsearch = true   -- highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true  -- but make it case sensitive if an uppercase is entered

vim.g.mapleader = " "
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250
vim.opt.splitkeep = "screen"       -- new
vim.opt.grepprg = "rg --vimgrep"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰌶 ",
      [vim.diagnostic.severity.HINT] = " ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    -- source = "if_many",
    -- prefix = "",
    format = function(diag)
      local msg = ""
      if diag.severity == vim.diagnostic.severity.ERROR or diag.severity == vim.diagnostic.severity.WARN then
        msg = string.format("%s / %s", diag.message, diag.source)
        if diag.code then
          msg = string.format("%s[%s]", msg, diag.code)
        end
        return msg
      end
      return diag.message
    end
    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
    -- prefix = "icons",
  },
  severity_sort = true,
  float = {
    border = "rounded"
  },
}
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
