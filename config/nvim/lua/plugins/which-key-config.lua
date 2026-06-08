-- Configurar which-key para mostrar los atajos de IA y otros comandos
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        {
          "<leader>a",
          group = "AI / Claude",
          icon = "󰭹",
          {
            "<leader>aa",
            desc = "Avante (chat + edits)",
            icon = "💬",
          },
          {
            "<leader>ae",
            desc = "Avante (edit code)",
            icon = "✏️",
          },
          {
            "<leader>ac",
            desc = "Claude Code (toggle)",
            icon = "󰚀",
          },
          {
            "<leader>aA",
            desc = "Claude Code (nueva sesión)",
            icon = "🔄",
          },
          {
            "<leader>at",
            desc = "Terminal Claude (flotante)",
            icon = "💻",
          },
          {
            "<leader>aT",
            desc = "Terminal flotante",
            icon = "⌨️",
          },
        },
        {
          "<leader>c",
          group = "Code",
          icon = "󰘦",
          {
            "<leader>cv",
            desc = "Select VirtualEnv",
            icon = "🐍",
          },
          {
            "<leader>cV",
            desc = "Reuse VirtualEnv",
            icon = "♻️",
          },
          {
            "<leader>cm",
            desc = "Mason (LSP/tools)",
            icon = "🔧",
          },
          {
            "<leader>cl",
            desc = "LSP Info",
            icon = "ℹ️",
          },
          {
            "<leader>cd",
            desc = "Line Diagnostics",
            icon = "⚠️",
          },
          {
            "<leader>cr",
            desc = "Rename symbol",
            icon = "📝",
          },
          {
            "<leader>ca",
            desc = "Code action",
            icon = "⚡",
          },
        },
      },
    },
  },
}
