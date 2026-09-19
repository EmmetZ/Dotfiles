return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        float = {
          transparent = true, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        transparent_background = true,
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        integrations = {
          noice = true,
          snacks = {
            enabled = true,
          },
        },
        highlight_overrides = {
          macchiato = function(macchiato)
            return {
              lineNr = { fg = macchiato.overlay0 },
            }
          end,
        },
      })
      local palette = require("catppuccin.palettes").get_palette("macchiato")
      local hl_list = { "Pmenu", "LazyNormal", "MasonNormal", "NoicePopup", "BlinkCmpDoc" }
      for _, hl in ipairs(hl_list) do
        vim.api.nvim_set_hl(0, hl, { bg = palette.crust })
      end
    end,
  },
}
