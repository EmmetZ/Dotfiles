return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  config = function()
    local map = vim.keymap.set
    map("n", "]t", function()
      require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    map("n", "[t", function()
      require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
    require("todo-comments").setup()

    map("n", "<leader>ol", "<CMD>Trouble todo focus=true<CR>", { desc = "TODO list(Trouble)" })
    -- map("n", "<leader>ol", "<CMD>TodoLocList<CR>", { desc = "TODO loc list" })
    -- map("n", "<leader>op", "<CMD>TodoTelescope<CR>", { desc = "TODO Telescope" })
  end
}
