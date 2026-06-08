-- Python + Django: venv support, pyright, ruff, djlint
return {

  -- ── Virtual Environment Selector ──────────────────────────────────────────
  {
    "linux-cultist/venv-selector.nvim",
    branch       = "regexp",   -- newer API branch
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
    },
    ft      = "python",
    cmd     = { "VenvSelect", "VenvSelectCached" },
    opts = {
      settings = {
        search = {
          -- Search locations (in order): .venv in project, venv, ~/virtualenvs, pipenv, poetry
          venvs = {
            command = "fd -HI --no-ignore-vcs -t d 'python' .",
          },
        },
        options = {
          -- Notify when virtualenv is activated
          notify_user_on_venv_activation = true,
          set_environment_variables = true,
          activate_venv_in_shell = true,
          parents = 2,
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>",       desc = "Select VirtualEnv",     ft = "python" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Reuse last VirtualEnv", ft = "python" },
    },
  },

  -- ── Pyright: override LazyVim defaults for Django projects ────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- basedpyright is what LazyVim's python extra installs by default.
        -- Override settings to handle Django's src layout and virtual envs.
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode      = "basic",    -- reducido a "basic" para Django
                autoImportCompletions = true,
                autoSearchPaths       = true,
                useLibraryCodeForTypes = true,
                diagnosticMode        = "workspace",
                -- Ignorar errores de módulos sin stubs (common en Django)
                reportMissingModuleSource = "none",
              },
            },
          },
        },
        -- Also configure plain pyright as fallback (Mason might install either)
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode      = "basic",
                autoImportCompletions = true,
                autoSearchPaths       = true,
                useLibraryCodeForTypes = true,
                diagnosticMode        = "workspace",
              },
            },
          },
        },
      },
    },
  },

  -- ── nvim-lint: add djlint for Django templates ───────────────────────────
  -- LazyVim's python extra already sets up ruff; this only adds djlint on top.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      -- Add djlint for Django templates
      opts.linters_by_ft["htmldjango"] = { "djlint" }
      return opts
    end,
  },

  -- ── conform.nvim: format Django templates with djlint ─────────────────────
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft["htmldjango"] = { "djlint" }
      opts.formatters_by_ft["python"]     = { "ruff_format", "ruff_organize_imports" }
      return opts
    end,
  },

  -- ── Mason: ensure Python tools are installed ──────────────────────────────
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "basedpyright",
        "ruff",
        "djlint",
        "black",
        "isort",
      })
    end,
  },
}
