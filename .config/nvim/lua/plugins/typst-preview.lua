local server = require("plugins.lsp.servers")

return {
  'chomosuke/typst-preview.nvim',
  -- lazy = false, -- or ft = 'typst'
  ft = 'typst',
  version = '1.*',
  build = function() require 'typst-preview'.update() end,
  opts = {
    open_cmd = 'google-chrome %s --new-window',
    dependencies_bin = {
      ['tinymist'] = server.tinymist.cmd[1],
      ['websocat'] = nil
    },
  },
  config = function (_, opts)
    vim.keymap.set('n', '<leader>mt', "<CMD>TypstPreview<CR>", { noremap = true, desc = "Typst Preview" })
    require("typst-preview").setup(opts)
  end
}
