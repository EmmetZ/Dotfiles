-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local util = require("lspconfig.util")
local servers = {
  clangd = {
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern(
        "Makefile",
        "configure.ac",
        "configure.in",
        "config.h.in",
        "meson.build",
        "meson_options.txt",
        "build.ninja"
      )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
        fname
      ) or require("lspconfig.util").find_git_ancestor(fname)
    end,
    capabilities = {
      offsetEncoding = { "utf-16" },
      -- semanticTokensProvider = nil,
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--all-scopes-completion=true",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
      "--suggest-missing-includes",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },
  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
        diagnostics = {
          globals = { "vim" }, -- Recognize 'vim' as a global variable
        },
      },
    },
  },
  tinymist = {
    --- todo: these configuration from lspconfig maybe broken
    cmd = { "/home/baiyx/.vscode/extensions/myriad-dreamin.tinymist-0.13.10-linux-x64/out/tinymist" },
    single_file_support = true,
    root_dir = function()
      return vim.fn.getcwd()
    end,
    -- offset_encoding = "utf-8",
    --- See [Tinymist Server Configuration](https://github.com/Myriad-Dreamin/tinymist/blob/main/Configuration.md) for references.
    settings = {
      formatterMode = 'typstyle',
      semanticTokens = "disable",
      -- exportPdf = "onType",
    },
    on_attach = function(client, _)
      if client then
        vim.keymap.set("n", "<leader>mc", function()
          local path = vim.api.nvim_buf_get_name(0)
          vim.notify(string.format("compiling %s", path), vim.log.levels.INFO)
          vim.fn.system(string.format("typst compile %s", path))
          if vim.v.shell_error == 0 then
            local pdf_path = path:gsub("%.typ$", ".pdf")
            vim.notify("success: " .. pdf_path, vim.log.levels.INFO)
          else
            vim.notify(string.format("compile error"), vim.log.levels.ERROR)
          end
        end, { desc = "Typst compile pdf" })
      end
    end
  },
  rust_analyzer = {
    cmd = { "/home/baiyx/.vscode/extensions/rust-lang.rust-analyzer-0.3.2379-linux-x64/server/rust-analyzer" },
    ft = { "rust" },
    root_dir = util.root_pattern("Cargo.toml"),
    on_attach = function()
      vim.lsp.inlay_hint.enable(true)

      for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then
            return
          end
          return default_diagnostic_handler(err, result, context, config)
        end
      end
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },

  ruff = {
    cmd_env = { RUFF_TRACE = "messages" },
    init_options = {
      settings = {
        logLevel = "error",
        lint = {
          enable = true,
          preview = true,
        },
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
      if client.supports_method("textDocument/codeAction") then
        vim.keymap.set("n", "<leader>co", function()
          vim.lsp.buf.code_action(
            {
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            }
          )
        end, { desc = "Organize Imports" })
      end
    end,
  },

  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  vtsls = {
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
    keys = {
      {
        "<leader>co",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          })
        end,
        desc = "Organize Imports",
      },
      {
        "<leader>cu",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.removeUnused.ts" },
              diagnostics = {},
            },
          })
        end,
        desc = "Remove unused imports",
      },
    },
  },

  -- texlab = {},
  -- gopls = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},
  --
}
return servers
