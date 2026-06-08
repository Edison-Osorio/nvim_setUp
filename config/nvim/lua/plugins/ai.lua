-- ══════════════════════════════════════════════════════════════════════════════
-- Integraciones con Claude / IA
--
-- Opción A: claude-code.nvim  → abre Claude Code CLI en ventana flotante
--           Atajo: <leader>ac  |  no necesita API key, usa el CLI instalado
--
-- Opción B: avante.nvim       → experiencia tipo Cursor (chat + edits inline)
--           Atajo: <leader>aa  |  REQUIERE: export ANTHROPIC_API_KEY="sk-..."
--
-- Opción C: terminal flotante → fallback simple, siempre disponible
--           Atajo: <leader>at
-- ══════════════════════════════════════════════════════════════════════════════

-- ── A: claude-code.nvim ──────────────────────────────────────────────────────
-- Envuelve el CLI de Claude Code en una ventana dentro de Neovim.
-- El contexto del proyecto lo maneja Claude Code por sí solo (igual que en terminal).
local M_claude_code = {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ac", desc = "Claude Code (toggle)" },
    { "<leader>aA", desc = "Claude Code (nueva sesión)" },
  },
  cmd = { "ClaudeCode", "ClaudeCodeContinue" },
  opts = {
    window = {
      position    = "vertical",  -- "vertical" | "horizontal" | "float" | "tab"
      split_ratio = 0.38,        -- 38% del ancho de pantalla
      enter_insert = true,       -- entrar en modo insert al abrir
      hide_numbers = true,
      hide_signcolumn = true,
    },
    keymaps = {
      toggle = {
        normal   = "<leader>ac",
        terminal = "<leader>ac",
      },
      window_navigation = true,   -- <C-h/j/k/l> para moverse entre paneles
      scrolling = true,
    },
  },
}

-- ── B: avante.nvim ───────────────────────────────────────────────────────────
-- Experiencia tipo Cursor: panel de chat + diff inline + selección de código.
-- REQUIERE: ANTHROPIC_API_KEY en el entorno o en ~/.zshrc
--   export ANTHROPIC_API_KEY="sk-ant-..."
local M_avante = {
  "yetone/avante.nvim",
  event   = "VeryLazy",
  version = false,
  build   = "make",     -- compila el módulo nativo (necesita make y gcc — ya instalados)
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    -- Render de markdown en el panel de chat
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft   = { "markdown", "Avante" },
    },
    -- Pegar imágenes en el chat (útil para compartir screenshots de errores)
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts  = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name  = false,
          drag_and_drop         = { insert_mode = true },
          use_absolute_path     = true,
        },
      },
    },
  },
  opts = {
    -- Proveedor principal: Claude via API de Anthropic
    provider = "claude",
    providers = {
      claude = {
        endpoint   = "https://api.anthropic.com",
        model      = "claude-sonnet-4-6",   -- cambiar a "claude-opus-4-8" para máxima capacidad
        timeout    = 30000,
        extra_request_body = {
          temperature = 0,
          max_tokens = 8096,
        },
      },
    },

    behaviour = {
      auto_suggestions               = false,  -- activar si quieres sugerencias inline continuas
      auto_set_highlight_group       = true,
      auto_set_keymaps               = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard   = true,
    },

    -- Panel lateral
    windows = {
      position = "right",
      wrap     = true,
      width    = 35,      -- porcentaje del ancho de pantalla
      sidebar_header = {
        align   = "center",
        rounded = true,
      },
    },

    -- Atajos para el diff (cuando avante propone cambios)
    mappings = {
      diff = {
        ours     = "co",  -- aceptar versión actual
        theirs   = "ct",  -- aceptar versión de Claude
        both     = "cb",  -- aceptar ambas
        next     = "]x",
        prev     = "[x",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      -- Abrir/cerrar panel
      ask      = "<leader>aa",
      edit     = "<leader>ae",  -- editar selección visual
      refresh  = "<leader>ar",
    },

    highlights = {
      diff = {
        current  = "DiffText",
        incoming = "DiffAdd",
      },
    },
  },
}

-- ── C: Terminal flotante con Claude Code ─────────────────────────────────────
-- Sin plugins extra. Usa el terminal integrado de Neovim.
-- Útil como fallback cuando no hay API key o quieres sesión rápida.
local M_terminal = {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>at", desc = "Claude Code (terminal flotante)" },
    { "<leader>aT", desc = "Terminal flotante" },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then return 18
      elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.4)
      end
    end,
    open_mapping    = nil,
    hide_numbers    = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size    = true,
    direction       = "float",
    close_on_exit   = true,
    shell           = vim.o.shell,
    float_opts = {
      border   = "rounded",
      width    = math.floor(vim.o.columns * 0.85),
      height   = math.floor(vim.o.lines * 0.80),
      winblend = 3,
    },
    highlights = {
      FloatBorder = { link = "FloatBorder" },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal

    -- Terminal dedicada para Claude Code CLI
    local claude_term = Terminal:new({
      cmd       = "claude",
      direction = "float",
      hidden    = true,
      on_open = function(t)
        vim.cmd("startinsert!")
        -- Salir del terminal con <Esc>
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = t.bufnr })
      end,
    })

    -- Terminal flotante genérica
    local float_term = Terminal:new({
      direction = "float",
      hidden    = true,
      on_open = function(t)
        vim.cmd("startinsert!")
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = t.bufnr })
      end,
    })

    vim.keymap.set("n", "<leader>at", function() claude_term:toggle() end,
      { desc = "Claude Code (terminal flotante)" })
    vim.keymap.set("n", "<leader>aT", function() float_term:toggle() end,
      { desc = "Terminal flotante" })
  end,
}

return { M_claude_code, M_avante, M_terminal }
