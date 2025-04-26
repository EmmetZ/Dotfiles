return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      integrations = {
        noice = true,
      },
      highlight_overrides = {
        macchiato = function(macchiato)
          return {
            lineNr = { fg = macchiato.overlay0 }
          }
        end
      },
    })
    vim.cmd.colorscheme "catppuccin"
    local palette = require("catppuccin.palettes").get_palette "macchiato"
    -- local util = require("catppuccin.utils.colors")
    -- local bg = util.darken(palette.base, 0.5, palette.crust)
    local hl_list = { "Pmenu", "LazyNormal", "MasonNormal", "NoicePopup", "BlinkCmpDoc" }
    for _, hl in ipairs(hl_list) do
      vim.api.nvim_set_hl(0, hl, { bg = palette.crust })
    end

    -- blink.cmp
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = palette.overlay2 })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = palette.overlay2 })

    -- indent-blankline
    vim.api.nvim_set_hl(0, "IncSearch", { bg = palette.peach, fg = palette.base })
    vim.api.nvim_set_hl(0, "IblScope", { fg = palette.surface2 })
    -- vim.api.nvim_set_hl(0, "IblScope", { fg = palette.lavender })

    -- snacks
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = palette.lavender })
    vim.api.nvim_set_hl(0, "SnacksDashBoardDesc", { fg = palette.lavender })
    vim.api.nvim_set_hl(0, "SnacksDashBoardIcon", { fg = palette.lavender })

    -- telescope
    -- local utils = require("catppuccin.utils.colors")
    -- local prompt_bg = utils.darken(palette.surface0, 0.5, palette.base)
    -- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = palette.crust, fg = palette.crust })
    -- vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.blue })
    -- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.crust })
    -- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = prompt_bg, fg = prompt_bg })
    -- vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = prompt_bg, fg = palette.text })
    -- vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = prompt_bg, fg = palette.flamingo })
    -- vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = palette.green, fg = palette.base })
    -- vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = palette.red, fg = palette.base })
    -- vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = palette.lavender, fg = palette.mantle })
    -- vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = prompt_bg, fg = palette.flamingo, bold = true })
    -- vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = palette.flamingo })

    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
    -- vim.api.nvim_set_hl(0, "FlashPrompt", { bg = 'none' })
  end
}
