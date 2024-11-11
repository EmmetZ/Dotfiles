return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup({
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_x = { "encoding", "filetype" },
      }
    })
  end
}
