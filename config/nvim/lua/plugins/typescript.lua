-- TypeScript + Angular: ts_ls, angularls, eslint, prettier
local util = require("lspconfig.util")

-- Locate TypeScript lib — prefer project-local, fall back to Mason's copy
local function get_typescript_lib(root_dir)
  local local_ts = util.path.join(root_dir, "node_modules", "typescript", "lib")
  if vim.fn.isdirectory(local_ts) == 1 then
    return local_ts
  end
  -- Mason installs typescript-language-server which bundles typescript
  return vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
end

-- Locate the angular-language-server node_modules installed by Mason
local function get_angular_probe(root_dir)
  local local_ng = util.path.join(root_dir, "node_modules")
  if vim.fn.isdirectory(local_ng) == 1 then
    return local_ng
  end
  return vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules"
end

return {

  -- ── Angular Language Server ───────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ts_ls: TypeScript LSP — LazyVim's typescript extra configures this,
        -- but we extend with inlay hints and stricter settings.
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints              = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints      = true,
                includeInlayVariableTypeHints               = false,
                includeInlayPropertyDeclarationTypeHints    = true,
                includeInlayFunctionLikeReturnTypeHints     = true,
                includeInlayEnumMemberValueHints            = true,
              },
              preferences = {
                importModuleSpecifier = "relative",  -- prefer relative imports in Angular
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints           = "literals",
                includeInlayFunctionParameterTypeHints   = true,
                includeInlayVariableTypeHints            = false,
                includeInlayFunctionLikeReturnTypeHints  = true,
                includeInlayEnumMemberValueHints         = true,
              },
            },
          },
        },

        -- angularls: Angular Language Server
        -- Activated only inside Angular projects (detected by angular.json)
        angularls = {
          root_dir = util.root_pattern("angular.json", "project.json", ".git"),
          filetypes = { "typescript", "html", "typescriptreact" },
          -- Rebuild the cmd so it points to the right TypeScript + Angular probes
          on_new_config = function(new_config, new_root_dir)
            local ts_probe  = get_typescript_lib(new_root_dir)
            local ng_probe  = get_angular_probe(new_root_dir)
            new_config.cmd = {
              "ngserver",
              "--stdio",
              "--tsProbeLocations", ts_probe,
              "--ngProbeLocations",  ng_probe,
            }
          end,
        },
      },

      -- Prevent angularls and ts_ls from fighting over the same TS files
      setup = {
        angularls = function(_, opts)
          require("lspconfig").angularls.setup(opts)
          return true  -- tell LazyVim "I handled setup myself"
        end,
      },
    },
  },

  -- ── Treesitter: ensure Angular templates are highlighted ─────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "scss",
        "json",
        "graphql",   -- common in Angular + Django REST APIs
      })
      return opts
    end,
  },

  -- ── conform.nvim: Prettier for TS/HTML/CSS/SCSS/JSON ─────────────────────
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local prettier_fts = {
        "typescript", "typescriptreact",
        "javascript", "javascriptreact",
        "html", "css", "scss", "less",
        "json", "jsonc", "yaml",
        "graphql", "markdown",
      }
      for _, ft in ipairs(prettier_fts) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end
      -- Use project-local prettier config if present
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        require_cwd  = false,
        condition    = function(_, ctx)
          -- skip if no prettier config found and no .prettierrc
          return vim.fs.find(
            { ".prettierrc", ".prettierrc.js", ".prettierrc.json", "prettier.config.js" },
            { path = ctx.filename, upward = true }
          )[1] ~= nil
        end,
      }
      return opts
    end,
  },

  -- ── Mason: ensure Angular + TS tools are installed ────────────────────────
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript-language-server",
        "angular-language-server",
        "eslint-lsp",
        "prettier",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "tailwindcss-language-server",
      })
    end,
  },
}
