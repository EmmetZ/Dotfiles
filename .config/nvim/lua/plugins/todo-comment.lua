return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "]t", "<CMD>TodoTrouble<CR>", desc = "Next todo comment" },
    { "[t", "<CMD>TodoTrouble<CR>", desc = "Previous todo comment" },
    { "<leader>ol", "<CMD>TodoTrouble<CR>", desc = "TODO list(Trouble)" },
    -- { "<leader>op", "<CMD>TodoTelescope<CR>", desc = "TODO Telescope" },
  },
}

