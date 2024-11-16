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
            }
        })
        vim.cmd.colorscheme "catppuccin"
        local palette = require("catppuccin.palettes").get_palette "macchiato"
        vim.api.nvim_set_hl(0, "IncSearch", { bg = palette.peach, fg = palette.base })
    end
}

