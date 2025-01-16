return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
      flavour = "macchiato",       -- latte, frappe, macchiato, mocha
      integrations = {
        noice = true,
        blink_cmp = true,
      },
      highlight_overrides = {
        macchiato = function(macchiato)
          return {
            lineNr = { fg = macchiato.surface2 }
          }
        end
      },
    })
    vim.cmd.colorscheme "catppuccin"
    local palette = require("catppuccin.palettes").get_palette "macchiato"
    -- local util = require("catppuccin.utils.colors")
    -- local bg = util.darken(palette.base, 0.5, palette.crust)
    local hl_list = { "Pmenu", "LazyNormal", "MasonNormal", "WhichKeyNormal", "NoicePopup", "BlinkCmpDoc" }
    for _, hl in ipairs(hl_list) do
      vim.api.nvim_set_hl(0, hl, { bg = palette.crust })
    end
    vim.api.nvim_set_hl(0, "IncSearch", { bg = palette.peach, fg = palette.base })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
    -- vim.api.nvim_set_hl(0, "FlashPrompt", { bg = 'none' })
    -- vim.api.nvim_set_hl(0, "IblScope", { fg = palette.lavender })
    vim.api.nvim_set_hl(0, "IblScope", { fg = palette.surface2 })
    -- vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = palette.flamingo, bg = palette.surface0, bold = true })
  end
}
