local server = require("plugins.lsp.servers")

return {
  'chomosuke/typst-preview.nvim',
  -- lazy = false, -- or ft = 'typst'
  ft = 'typst',
  version = '1.*',
  build = function() require 'typst-preview'.update() end,
  opts = {
    -- open_cmd = 'google-chrome %s --new-window',
    open_cmd = 'firefox -P typst --new-window %s',
    dependencies_bin = {
      ['tinymist'] = server.tinymist.cmd[1],
      ['websocat'] = nil
    },
  },
  config = function (_, opts)
    vim.keymap.set('n', '<leader>mp', "<CMD>TypstPreview<CR>", { noremap = true, desc = "Typst Preview" })
    vim.keymap.set('n', '<leader>ms', "<CMD>TypstPreviewStop<CR>", { noremap = true, desc = "Typst Preview Stop" })
    require("typst-preview").setup(opts)
  end
}
