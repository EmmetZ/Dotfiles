return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  -- lazy = false,
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  },
  opts = {
    options = {
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' }
      },
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level, _, _)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
    local map = vim.keymap.set
    map("n", "<leader>x", function()
      local buffer_id = vim.fn.bufnr()
      vim.cmd "BufferLineCyclePrev"
      vim.cmd("bdelete " .. buffer_id)
    end, { desc = "Close current buffer and go to previous" })
    for i = 1, 9, 1 do
      map({ "n", "i" }, "<M-" .. i .. ">", "<CMD>lua require('bufferline').go_to(" .. i .. ", true)<CR>",
        { noremap = true, desc = "Goto buffer " .. i })
    end

    map("n", "gb", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer" })
    map("n", "gB", "<CMD>BufferLinePickClose<CR>", { desc = "Pick buffer and close it" })
  end,
}
