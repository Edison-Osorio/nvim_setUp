#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Neovim + LazyVim — dependencias del sistema
# Compatible: Fedora 44 / macOS
# Stacks: TypeScript · Angular · Python · Django
#
# ESTRUCTURA DE LA CONFIGURACIÓN:
#   ~/.config/nvim/init.lua              → bootstrap lazy.nvim + LazyVim
#   ~/.config/nvim/lua/config/           → opciones, keymaps, autocmds
#   ~/.config/nvim/lua/plugins/          → extensiones por stack
#
# LazyVim (https://lazyvim.org) actúa como "distro" de Neovim:
#   - Instala y gestiona todos los plugins via lazy.nvim
#   - Proporciona extras preconfiguredos (lang.typescript, lang.python, etc.)
#   - Mason instala los LSP servers automáticamente al abrir nvim
#
# Dependencias de sistema que LazyVim necesita presentes ANTES de abrir nvim:
#   neovim ≥ 0.9  git  ripgrep  fd  lazygit  gcc  unzip  node(NVM)
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step() { echo -e "\n${BLUE}━━━ $1 ━━━${NC}"; }

# ── OS detection ──────────────────────────────────────────────────────────────
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"
  elif grep -qi fedora /etc/os-release 2>/dev/null; then echo "fedora"
  else err "OS no soportado. Solo Fedora y macOS."
  fi
}
OS=$(detect_os)
log "Sistema detectado: $OS"

# ── NVM + Node.js LTS (cross-platform) ───────────────────────────────────────
# Se instala antes que el resto para que `npm` esté disponible en el PATH
# desde el inicio del setup y en todas las sesiones futuras de shell.
install_nvm() {
  step "Instalando NVM (Node Version Manager)"

  export NVM_DIR="$HOME/.nvm"

  if [[ -d "$NVM_DIR" ]]; then
    log "NVM ya existe en $NVM_DIR — actualizando..."
  fi

  # Obtener la última versión estable de NVM desde GitHub
  NVM_LATEST=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)
  log "Instalando NVM $NVM_LATEST..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST}/install.sh" | bash

  # Cargar NVM en la sesión actual del script
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Asegurar que el sourcing esté en el rc del shell activo
  SHELL_RC=""
  if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
  elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
  fi

  if [[ -n "$SHELL_RC" ]]; then
    if ! grep -q 'NVM_DIR' "$SHELL_RC" 2>/dev/null; then
      cat >> "$SHELL_RC" <<'EOF'

# NVM — Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
      log "Sourcing de NVM agregado a $SHELL_RC"
    else
      log "NVM ya está en $SHELL_RC"
    fi
  fi

  # Instalar y usar Node LTS como versión por defecto
  log "Instalando Node.js LTS..."
  nvm install --lts
  nvm use --lts
  nvm alias default 'lts/*'
  log "Node $(node --version) · npm $(npm --version) — via NVM"
}

# ── Fedora: dependencias de sistema ──────────────────────────────────────────
install_fedora() {
  step "Instalando dependencias del sistema (dnf)"

  # Neovim estable desde los repos de Fedora 44 (≥ 0.10)
  sudo dnf install -y \
    neovim \
    git curl wget unzip \
    ripgrep fd-find \
    gcc gcc-c++ make \
    python3-pip python3-devel \
    xclip xsel          # clipboard desde terminal

  # lazygit — UI de git integrada en LazyVim (<Space>gg)
  if ! command -v lazygit &>/dev/null; then
    log "Instalando lazygit via COPR..."
    sudo dnf copr enable atim/lazygit -y 2>/dev/null \
      && sudo dnf install -y lazygit \
      || warn "lazygit no pudo instalarse — instalar manualmente desde https://github.com/jesseduffield/lazygit"
  else
    log "lazygit ya instalado: $(lazygit --version 2>/dev/null | head -1)"
  fi

  # Kitty — terminal moderna con soporte de splits
  if ! command -v kitty &>/dev/null; then
    log "Instalando kitty..."
    sudo dnf install -y kitty
  else
    log "kitty ya instalado: $(kitty --version)"
  fi
}

# ── macOS: dependencias de sistema ───────────────────────────────────────────
install_macos() {
  step "Instalando dependencias (Homebrew)"

  if ! command -v brew &>/dev/null; then
    warn "Homebrew no encontrado, instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Cargar brew en esta sesión (Apple Silicon path)
    [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew install neovim git ripgrep fd unzip lazygit kitty

  # python3 en macOS (para las herramientas de LSP)
  command -v python3 &>/dev/null || brew install python3
}

# ── NPM: LSP servers instalados globalmente via NVM ──────────────────────────
# Estos se instalan en ~/.nvm/versions/node/<version>/lib/node_modules/
# Mason también instala algunos, pero tener versiones globales acelera el setup.
install_npm_tools() {
  step "Instalando LSP servers y herramientas via npm"

  npm install -g \
    typescript \
    typescript-language-server \
    "@angular/language-server" \
    prettier \
    eslint \
    vscode-langservers-extracted    # html · css · json LSPs

  log "npm tools instalados en: $(npm root -g)"
}

# ── Python: herramientas de LSP y formateo ────────────────────────────────────
install_python_tools() {
  step "Instalando herramientas Python (LSP, linters, formatters)"

  python3 -m pip install --user --upgrade pip

  python3 -m pip install --user \
    pyright \
    ruff \
    black \
    isort \
    djlint    # linter/formatter para templates Django

  log "Python tools instalados en: $(python3 -m site --user-site)"
}

# ── Configuración de Neovim ──────────────────────────────────────────────────
install_nvim_config() {
  step "Instalando configuración de Neovim"

  NVIM_CONFIG_DIR="$HOME/.config/nvim"

  if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    warn "~/.config/nvim ya existe — se hará backup en ~/.config/nvim.bak"
    rm -rf "$HOME/.config/nvim.bak"
    mv "$NVIM_CONFIG_DIR" "$HOME/.config/nvim.bak"
  fi

  mkdir -p "$NVIM_CONFIG_DIR"
  cp -r "$SCRIPT_DIR/config/nvim/." "$NVIM_CONFIG_DIR/"
  log "Configuración de Neovim instalada en $NVIM_CONFIG_DIR"
}

# ── Configuración de Kitty ──────────────────────────────────────────────────
install_kitty_config() {
  step "Configurando Kitty"

  KITTY_CONFIG_DIR="$HOME/.config/kitty"
  mkdir -p "$KITTY_CONFIG_DIR"
  cp "$SCRIPT_DIR/config/kitty/kitty.conf" "$KITTY_CONFIG_DIR/kitty.conf"
  log "Configuración de Kitty instalada en $KITTY_CONFIG_DIR/kitty.conf"
}

# ── Nota sobre Nerd Fonts ─────────────────────────────────────────────────────
nerd_font_notice() {
  echo ""
  echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${YELLOW}║  IMPORTANTE: Nerd Font requerida para íconos en LazyVim      ║${NC}"
  echo -e "${YELLOW}╠══════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${YELLOW}║  LazyVim usa íconos de Nerd Fonts. Sin una Nerd Font activa  ║${NC}"
  echo -e "${YELLOW}║  verás símbolos rotos (□□□) en el statusline y el explorer.  ║${NC}"
  echo -e "${YELLOW}║                                                              ║${NC}"
  echo -e "${YELLOW}║  Opciones recomendadas:                                      ║${NC}"
  echo -e "${YELLOW}║    Fedora:  sudo dnf install cascadia-code-fonts             ║${NC}"
  echo -e "${YELLOW}║    macOS:   brew install --cask font-jetbrains-mono-nerd-font║${NC}"
  echo -e "${YELLOW}║    Manual:  https://www.nerdfonts.com/font-downloads         ║${NC}"
  echo -e "${YELLOW}║             (recomendado: JetBrainsMono o FiraCode)          ║${NC}"
  echo -e "${YELLOW}║                                                              ║${NC}"
  echo -e "${YELLOW}║  Después de instalar la fuente, configúrala en tu terminal.  ║${NC}"
  echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# ── Ejecución ─────────────────────────────────────────────────────────────────
install_nvm                          # NVM primero — instala node/npm

case $OS in
  fedora) install_fedora ;;
  macos)  install_macos  ;;
esac

install_nvim_config
install_kitty_config
install_npm_tools
install_python_tools
nerd_font_notice

# ── Resumen final ─────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Instalación completada. Abre Kitty para comenzar.        ║${NC}"
echo -e "${GREEN}║    ~/.config/nvim/  — configuración de Neovim               ║${NC}"
echo -e "${GREEN}║    ~/.config/kitty/ — configuración de Kitty                ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  KITTY — Atajos disponibles:"
echo "    Ctrl+Shift+T       → Nueva pestaña"
echo "    Ctrl+Shift+H/L     → Tab anterior/siguiente"
echo "    Ctrl+Shift+\\       → Split vertical"
echo "    Ctrl+Shift+-       → Split horizontal"
echo "    Ctrl+Shift+Q       → Cerrar split"
echo "    Ctrl+Shift+Z       → Maximizar/restaurar split (zoom)"
echo "    Alt+H/J/K/L        → Navegar entre splits"
echo "    Alt+Shift+H/J/K/L  → Redimensionar splits"
echo "    Ctrl+=/-, Ctrl+0   → Zoom de fuente"
echo ""
echo "  NEOVIM — Primer arranque:"
echo "    1. lazy.nvim clona LazyVim y todos los plugins"
echo "    2. nvim-treesitter compila parsers (TS, Python, HTML, CSS…)"
echo ""
echo "  NEOVIM — Atajos principales:"
echo "    <Space>cv   → VenvSelect     (elegir virtualenv Python)"
echo "    <Space>cm   → Mason          (gestión de LSP/linters)"
echo "    <Space>cl   → LspInfo        (ver LSP activo en el buffer)"
echo "    <Space>e    → Explorer       (árbol de archivos)"
echo "    <Space>gg   → lazygit"
echo "    <Space>/    → Grep en proyecto"
echo "    :LazyExtras → activar/desactivar extras de LazyVim"
echo "    :Lazy       → gestión de plugins"
echo ""
echo "  Versiones instaladas:"
echo "    Node  : $(node --version 2>/dev/null || echo 'reinicia el shell')"
echo "    npm   : $(npm --version 2>/dev/null || echo 'reinicia el shell')"
echo "    nvim  : $(nvim --version 2>/dev/null | head -1 || echo 'no encontrado')"
echo "    kitty : $(kitty --version 2>/dev/null || echo 'no encontrado')"
echo "    python: $(python3 --version 2>/dev/null)"
echo ""
