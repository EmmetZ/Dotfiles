return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      hints = { enabled = false },
      provider = "copilot",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        if vim.bo.filetype == 'AvanteInput' then
          return false
        else
          return true
        end
      end,
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    opts = function()
      local cmp = require("cmp")
      local auto_select = true
      return {
        enabled = function()
          return vim.bo.filetype == "AvanteInput"
        end,
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = function(fallback)
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              if cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                  }) then
                return
              end
            end
            return fallback()
          end,
        }),
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a",  group = "ai" },
        { "<leader>gm", group = "Copilot Chat" },
      },
    },
  },
}
