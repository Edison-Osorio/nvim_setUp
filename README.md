# Neovim + LazyVim + Kitty Setup

Configuración automatizada para instalar **Neovim con LazyVim**, **Kitty terminal** y todas las dependencias necesarias para desarrollo en TypeScript, Angular, Python y Django.

Compatible con **Fedora 44** y **macOS**.

## 📋 Requisitos previos

- **Fedora 44** o **macOS** (Intel/Apple Silicon)
- Conexión a Internet
- `sudo` acceso (para instalación de paquetes)

### Opcional pero recomendado:
- SSH key configurada en GitHub (para `git clone` con SSH)
- Nerd Font instalada (para íconos en Neovim/Kitty)

## 🚀 Instalación rápida

```bash
git clone git@github.com:Edison-Osorio/nvim_setUp.git
cd nvim_setUp
bash install.sh
```

> El script copia los archivos de `config/nvim/` y `config/kitty/` a `~/.config/`.  
> Si ya existe `~/.config/nvim/`, se guarda un backup en `~/.config/nvim.bak` antes de reemplazarla.

## 📦 Qué se instala

### Sistema
- **Neovim** ≥ 0.9
- **Kitty** — Terminal moderna con splits integrados
- **Node.js** LTS (via NVM — Node Version Manager)
- **Python 3** con herramientas de LSP

### Herramientas de desarrollo
- **git** — Control de versiones
- **ripgrep** — Búsqueda rápida de código
- **fd** — Búsqueda de archivos
- **lazygit** — UI de Git integrada en Neovim
- **gcc/g++** — Compiladores

### LSP Servers (via npm)
- TypeScript Language Server
- Angular Language Server
- ESLint, Prettier
- HTML/CSS/JSON LSPs

### Herramientas Python
- **Pyright** — LSP para Python
- **Ruff** — Linter/formatter
- **Black** — Code formatter
- **isort** — Organizador de imports
- **djlint** — Formatter para templates Django

## ⚙️ Configuración instalada

### Neovim
- **LazyVim** como distribución de Neovim
- **Mason** para gestión automática de LSP servers
- Plugins preconfiguredos para TypeScript, Python, Angular, Django
- Integración con lazygit

Ubicación: `~/.config/nvim/`

### Kitty
- **Tema:** Catppuccin Mocha (colores oscuros elegantes)
- **Fuente:** FiraCode Nerd Font
- **Splits** — Crea paneles dentro de la terminal
- **Tabs** — Múltiples pestañas con soporte de PWD

Ubicación: `~/.config/kitty/kitty.conf`

## ⌨️ Atajos principales

### Kitty Terminal

**Pestañas:**
```
Ctrl+Shift+T       → Nueva pestaña
Ctrl+Shift+H       → Pestaña anterior
Ctrl+Shift+L       → Pestaña siguiente
Ctrl+Shift+W       → Cerrar pestaña
```

**Splits (paneles):**
```
Ctrl+Shift+\       → Split vertical (paneles lado a lado |  )
Ctrl+Shift+-       → Split horizontal (paneles arriba/abajo ── )
Ctrl+Shift+Q       → Cerrar split activo
Ctrl+Shift+Z       → Maximizar/restaurar split (zoom)
```

**Navegar entre splits:**
```
Alt+H              → Ir al split izquierda
Alt+L              → Ir al split derecha
Alt+K              → Ir al split arriba
Alt+J              → Ir al split abajo
```

**Redimensionar splits:**
```
Alt+Shift+H        → Más estrecho
Alt+Shift+L        → Más ancho
Alt+Shift+K        → Más alto
Alt+Shift+J        → Más corto
Ctrl+Shift+=       → Igualar tamaños
```

**Zoom de fuente:**
```
Ctrl+Equal         → Aumentar fuente
Ctrl+Minus         → Disminuir fuente
Ctrl+0             → Tamaño normal
```

---

### Neovim + LazyVim

**Líder (Leader key):** `<Space>`

**Explorador de archivos:**
```
<Space>e           → Abrir/cerrar árbol de archivos
```

**Búsqueda y grep:**
```
<Space>/           → Buscar texto en el proyecto
<Space>*           → Buscar palabra bajo cursor
```

**LSP y diagnósticos:**
```
<Space>cl          → Ver información del LSP activo
<Space>cm          → Mason — gestión de LSP servers
<Space>cv          → VenvSelect — elegir virtualenv Python
<Space>cd          → Definición de símbolo
<Space>cD          → Declaración de símbolo
<Space>cr          → Renombrar símbolo
```

**Git integrado:**
```
<Space>gg          → Abrir lazygit (UI de Git)
```

**Plugins y configuración:**
```
:Lazy              → Gestión de plugins
:LazyExtras        → Activar/desactivar extras de LazyVim
:Mason             → Instalar/actualizar LSP servers
```

**Edición:**
```
<Space>j/k         → Mover línea arriba/abajo
<Space>/           → Toggle comentario
<Space>ca          → Code actions (refactors, fixes)
```

## 🔧 Primeros pasos después de instalar

### 1️⃣ Abre Kitty
```bash
kitty
```

### 2️⃣ Abre Neovim (dentro de Kitty)
```bash
nvim
```

### 3️⃣ Primer arranque (automático)
- LazyVim clonará todos los plugins
- Treesitter compilará los parsers necesarios
- Puede tardar 2-5 minutos

### 4️⃣ Segundo arranque (manual)
Ejecuta dentro de Neovim:
```
:MasonInstall
```

O simplemente abre un archivo `.ts`, `.py`, etc. y Mason lo hará automáticamente.

### 5️⃣ Configura una Nerd Font (importante)

**Fedora:**
```bash
sudo dnf install cascadia-code-fonts
# O JetBrainsMono:
sudo dnf install jetbrains-mono-fonts
```

**macOS:**
```bash
brew install --cask font-jetbrains-mono-nerd-font
# O FiraCode:
brew install --cask font-fira-code-nerd-font
```

Luego configúrala en tu emulador de terminal (Kitty ya está configurado con FiraCode).

## 📁 Estructura del repositorio

```
nvim_setUp/
├── install.sh                # Script principal de instalación
├── config/
│   ├── nvim/                 # Configuración de Neovim
│   │   ├── init.lua          # Bootstrap LazyVim
│   │   ├── lazy-lock.json    # Versiones fijadas de plugins
│   │   ├── lazyvim.json      # Extras activos de LazyVim
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── options.lua    # Opciones del editor
│   │       │   ├── keymaps.lua    # Atajos personalizados
│   │       │   └── autocmds.lua   # Autocomandos (filetypes, etc.)
│   │       └── plugins/
│   │           ├── colorscheme.lua  # Catppuccin Mocha
│   │           ├── typescript.lua   # Angular + TypeScript
│   │           ├── python.lua       # Python + Django
│   │           ├── ai.lua           # Asistente IA
│   │           ├── indent.lua       # Guías de indentación
│   │           ├── rainbow.lua      # Rainbow delimiters
│   │           ├── zen.lua          # Modo zen
│   │           └── which-key-config.lua
│   └── kitty/
│       └── kitty.conf        # Catppuccin Mocha + splits + keymaps
├── .gitignore
└── README.md
```

El script copia `config/nvim/` → `~/.config/nvim/` y `config/kitty/` → `~/.config/kitty/` al instalar.

## 🔄 Actualizar configuración

### Plugins de Neovim:
```nvim
:Lazy sync
```

### Kitty o archivos de Neovim:
Edita los archivos en `config/nvim/` o `config/kitty/` dentro del repo y haz commit + push.  
En la máquina destino, actualiza con:
```bash
git pull
# Luego copia los archivos manualmente si necesitas sobreescribir ~/.config/:
cp -r config/nvim/. ~/.config/nvim/
cp config/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

## 🐛 Solución de problemas

### Símbolos rotos (□□□) en Neovim
**Causa:** Nerd Font no instalada o no configurada.

**Solución:**
```bash
# Fedora
sudo dnf install cascadia-code-fonts

# macOS
brew install --cask font-jetbrains-mono-nerd-font
```

Luego configúrala en tu terminal.

### LSP no aparece
**Causa:** Mason no ha instalado los servers aún.

**Solución:**
1. Abre un archivo `.ts`, `.py`, etc.
2. Ejecuta `:Mason`
3. Instala los servers necesarios
4. Recarga el buffer: `:e`

### Node.js no encontrado después de instalar
**Causa:** NVM no se cargó en el shell actual.

**Solución:**
```bash
# Recarga tu shell
exec zsh
# o
exec bash

# Verifica
node --version
npm --version
```

### Kitty no inicia en macOS
**Causa:** Permisos de seguridad.

**Solución:**
```bash
# Abre Kitty desde Spotlight (Cmd+Space) o:
open /Applications/Kitty.app
```

### Error: "sudo: comando no encontrado" en Fedora
**Causa:** Usuario sin permisos sudo.

**Solución:**
```bash
# Como root
usermod -aG wheel tu_usuario
# Luego abre una nueva sesión de terminal
```

## 📊 Versiones después de instalar

El script imprime las versiones instaladas al finalizar:

```
Versiones instaladas:
  Node  : v20.x.x
  npm   : 10.x.x
  nvim  : v0.10.x
  kitty : 0.36.x
  python: Python 3.x.x
```

## 🎨 Personalizar

### Cambiar tema de Kitty
Edita `config/kitty/kitty.conf` en el repo y cambia los colores. Referencia de temas:
https://github.com/catppuccin/kitty

### Cambiar fuente de Kitty
```
# config/kitty/kitty.conf
font_family      Monospace Font Name
```

### Agregar plugins a Neovim
Agrega un archivo Lua en `config/nvim/lua/plugins/` del repo:
```lua
return {
  "autor/plugin-name",
  -- configuración aquí
}
```
Luego haz commit y push para que el cambio quede versionado.

## 📚 Recursos

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/user/)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Mason LSP Servers](https://github.com/williamboman/mason.nvim)
- [Catppuccin Theme](https://github.com/catppuccin/)

## ✨ Features incluidos

- ✅ Instalación automatizada para Fedora y macOS
- ✅ Kitty con splits y tabs integrados
- ✅ Neovim con LazyVim como distribución
- ✅ Soporte para TypeScript, Angular, Python, Django
- ✅ LSP, linters, formatters preinstalados
- ✅ Git integration (lazygit)
- ✅ Tema Catppuccin Mocha
- ✅ FiraCode Nerd Font optimizado

## 📝 Licencia

Este proyecto es de código abierto. Siéntete libre de modificarlo y adaptarlo a tus necesidades.

## 👨‍💻 Autor

**Edison Osorio**  
Email: edisonosorio96@gmail.com

---

¿Preguntas o problemas? Abre un issue en el repositorio.
