return {
  {
    "folke/snacks.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  {
    "akinsho/bufferline.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    version = "*", -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup({
        {
          close_after_yank = false,
        },
      })
    end,
  },
}
