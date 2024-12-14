vim.opt.termguicolors = true
return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    require('nvim-highlight-colors').setup({
      -- render = 'virtual',
      virtual_symbol = '󱓻',
      exclude_buftypes = {},
      exclude_filetypes = {
        "mason", "lazy",
      }
    })
  end
}
