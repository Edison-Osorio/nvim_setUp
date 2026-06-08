-- Zen Mode + Twilight — modo de enfoque sin distracciones
-- <leader>zz → activar Zen Mode (oculta UI)
-- <leader>zt → activar Twilight (atenúa código no relevante)
-- <leader>za → ambas a la vez (experiencia iA Writer)
return {

  -- ── Twilight: atenúa código fuera del bloque actual ──────────────────────
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,            -- cuánto oscurecer el código atenuado
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,        -- atenuar solo fuera del buffer actual
      },
      context = 10,              -- líneas de contexto antes/después del bloque actual
      treesitter = true,         -- usar treesitter para detectar bloques
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
        "for_statement",
        "while_statement",
      },
      exclude = {},              -- filetypes excluidos
    },
    cmd = "Twilight",
    keys = {
      { "<leader>zt", "<cmd>Twilight<cr>", desc = "Twilight (atenuar código)" },
    },
  },

  -- ── Zen Mode: oculta UI para escribir sin distracciones ──────────────────
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    opts = {
      window = {
        backdrop = 0.95,         -- oscuridad del fondo fuera de la ventana
        width = 120,             -- ancho de la ventana zen
        height = 1.0,            -- altura (1.0 = pantalla completa)
        options = {
          signcolumn = "no",
          number = true,         -- mostrar números de línea
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,         -- ocultar ruler
          showcmd = false,       -- ocultar comando actual
          laststatus = 0,        -- ocultar statusline
        },
        twilight = { enabled = false }, -- no activar twilight automáticamente
        gitsigns = { enabled = false }, -- ocultar gitsigns
        tmux = { enabled = false },
        kitty = {
          enabled = false,       -- desactivar zoom de Kitty
        },
      },
      on_open = function(win)
        -- Callback cuando se abre Zen Mode
        vim.cmd("IBLToggle")     -- ocultar indent guides
      end,
      on_close = function()
        -- Callback cuando se cierra Zen Mode
        vim.cmd("IBLToggle")     -- mostrar indent guides de nuevo
      end,
    },
    cmd = "ZenMode",
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode (UI limpia)" },
    },
  },

  -- ── Acceso rápido: ambos modos a la vez ────────────────────────────────
  {
    "folke/which-key.nvim",
    optional = true,
    config = function(_, opts)
      -- Agregar grupo de zen mode a which-key
      if opts.spec then
        table.insert(opts.spec, {
          "<leader>z",
          group = "Zen",
          icon = "✨",
          {
            "<leader>zz",
            desc = "Zen Mode (UI limpia)",
            icon = "📖",
          },
          {
            "<leader>zt",
            desc = "Twilight (atenuar código)",
            icon = "🌙",
          },
          {
            "<leader>za",
            desc = "Ambos (full focus)",
            icon = "🎯",
          },
        })
      end
    end,
  },

  -- ── Comando extra: activar ambos a la vez ──────────────────────────────
  {
    "folke/zen-mode.nvim",
    init = function()
      vim.api.nvim_create_user_command("ZenFull", function()
        vim.cmd("ZenMode")
        vim.cmd("Twilight")
      end, {})

      vim.api.nvim_create_user_command("ZenFullOff", function()
        vim.cmd("ZenMode")
        vim.cmd("Twilight")
      end, {})
    end,
    keys = {
      {
        "<leader>za",
        function()
          vim.cmd("ZenMode")
          vim.cmd("Twilight")
        end,
        desc = "Zen + Twilight (full focus)",
      },
    },
  },
}

-- Keymaps adicionales:
-- <leader>zz → Zen Mode solo (oculta UI)
-- <leader>zt → Twilight solo (atenúa código)
-- <leader>za → :ZenFull (ambos a la vez)
-- <leader>z? → mostrar opciones (which-key)
