-- Catppuccin — reemplaza el TokyoNight por defecto de LazyVim
return {
  -- 1. Definir el plugin de Catppuccin
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,   -- cargar antes que otros plugins de UI
    opts = {
      flavour           = "mocha",     -- latte | frappe | macchiato | mocha
      background        = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer     = false,
      term_colors            = true,   -- colorea la terminal embebida (:term)
      dim_inactive           = { enabled = false },

      styles = {
        comments    = { "italic" },
        conditionals = { "italic" },
        functions   = {},
        keywords    = { "italic" },
        strings     = {},
        variables   = {},
        numbers     = {},
        booleans    = {},
        properties  = {},
        types       = {},
        operators   = {},
      },

      -- Integración con los plugins que LazyVim instala
      integrations = {
        cmp             = true,
        gitsigns        = true,
        neo_tree        = true,
        telescope       = { enabled = true, style = "nvchad" },
        treesitter      = true,
        treesitter_context = true,
        mason           = true,
        which_key       = true,
        lsp_trouble     = true,
        noice           = true,
        notify          = true,
        mini            = { enabled = true, indentscope_color = "" },
        indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = false },
        dashboard       = true,
        bufferline      = true,

        -- LSP: usar undercurl para errores/warnings (se ve mejor con FiraCode)
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors      = { "italic" },
            hints       = { "italic" },
            warnings    = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors      = { "undercurl" },
            hints       = { "undercurl" },
            warnings    = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = { background = true },
        },
      },
    },
  },

  -- 2. Decirle a LazyVim que use Catppuccin como colorscheme activo
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
