local kind_icons = {
  Array         = " ",
  Boolean       = "󰨙 ",
  Class         = " ",
  Color         = " ",
  Constant      = "󰏿 ",
  Constructor   = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = "󰊕 ",
  Interface     = " ",
  Keyword       = " ",
  Method        = " ",
  Module        = " ",
  Namespace     = " ",
  Null          = "󰟢 ",
  Number        = "󰎠 ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = " ",
  String        = " ",
  Struct        = " ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = " ",
  Copilot       = " ",
}

return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = {
      "sources.completion.enabled_providers",
      -- "sources.compat",
      "sources.default",
    },
    dependencies = {
      -- "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      -- {
      --   "saghen/blink.compat",
      --   optional = true, -- make optional so it's only enabled if any extras need it
      --   opts = {},
      --   version = not vim.g.lazyvim_blink_main and "*",
      -- },
    },
    event = "InsertEnter",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { 'typst' },
            },
          },
        },
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 200,
        },
        -- ghost_text = {
        --   enabled = true,
        -- },
      },

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        -- compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-j>"] = { "select_next" },
        ["<C-k>"] = { "select_prev" },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("keep", {
        Color = "██", -- Use block instead of icon for color items to make swatches more usable
      }, kind_icons)
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function(opts)
      require("nvim-autopairs").setup(opts)
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      local cond = require("nvim-autopairs.conds")
      npairs.add_rules({
        Rule("$", "$", { "tex", "latex", "typst" })
            :with_pair(cond.not_after_regex("[%w%.]"))
            :replace_map_cr(function()
              return "<C-g>u<CR><C-c>O<Tab>"
            end)
      }
      )
    end
  },
}
