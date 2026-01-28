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
    "EmmetZ/kitty-scrollback.nvim",
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
    branch = "dev",
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
}
