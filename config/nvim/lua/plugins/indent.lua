-- Indent guides — mostrar SOLO la línea del scope actual cuando el cursor está dentro
-- Si estás fuera de cualquier función, no se muestra nada
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      -- DESACTIVAR las líneas de indentación normales (char vacío)
      indent = {
        char = "",
        smart_indent_cap = true,
      },

      -- ACTIVAR SOLO la línea del scope actual
      scope = {
        enabled      = true,
        -- Elige uno de estos caracteres:
        -- "│"   = línea sólida
        -- "⋮"   = tres puntos verticales
        -- "·"   = puntos individuales
        -- "︙"   = línea punteada fina (alternativa)
        char         = "⋮",    -- tres puntos (más compatible)
        show_start   = true,   -- mostrar en la línea de apertura {
        show_end     = true,   -- mostrar en la línea de cierre }
        highlight    = "IblScope",  -- color: rojo en Catppuccin
        priority     = 1000,
      },

      exclude = {
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        filetypes = {
          "lspinfo",
          "packer",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "TelescopePrompt",
          "TelescopeResults",
          "Trouble",
          "aerial",
          "alpha",
          "dashboard",
        },
      },
    },
  },
}
