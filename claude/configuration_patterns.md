# Devastation Configuration Patterns

## Overview

This document describes the configuration conventions and patterns used across all devastation containers for consistent, maintainable, and extensible development environments.

## Directory Structure Convention

### XDG Base Directory Specification
All devastation containers follow XDG standards for clean configuration management:

```
/home/$USERNAME/.config/
├── zsh/                    # Shell configuration
│   ├── .zshrc             # Main zsh config
│   ├── .p10k.zsh          # Powerlevel10k theme
│   └── ohmyzsh/           # Oh-My-Zsh framework
├── tmux/
│   └── tmux.conf          # Terminal multiplexer config
├── nvim/                  # Neovim configuration
│   ├── init.lua           # Entry point
│   ├── lua/
│   │   ├── plugins.lua    # Plugin definitions
│   │   └── config/        # Plugin configurations
├── claude/                # Claude Code authentication
├── git/                   # Git configuration
└── npm/                   # NPM configuration
```

### Environment Variables
- `ZDOTDIR=/home/$USERNAME/.config/zsh` - Zsh config location
- `NPM_CONFIG_USERCONFIG=/home/$USERNAME/.config/npm/npmrc`
- `NPM_CONFIG_CACHE=/home/$USERNAME/.config/npm/cache`
- `NPM_CONFIG_PREFIX=/home/$USERNAME/.config/npm/global`

## Neovim Configuration Architecture

### Plugin Management with Lazy.nvim
**File**: `lua/plugins.lua`

```lua
-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- Colorscheme
  {
    "altercation/vim-colors-solarized",
    config = function() require("config.colorscheme") end,
  },
  
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function() require("config.neo-tree") end,
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("config.telescope") end,
  },
  
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function() require("config.lsp-base") end,
  },
  
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function() require("config.cmp") end,
  },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("config.treesitter-base") end,
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("config.lualine") end,
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("config.gitsigns") end,
  },
  
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function() require("config.dap-base") end,
  },
})

-- Language-specific configurations appended here by Dockerfiles
-- Example: require("config.lsp-python")
```

### Configuration Module Pattern
Each plugin has a dedicated configuration file in `lua/config/`:

**Base Configuration Example** - `config/lsp-base.lua`:
```lua
-- Base LSP configuration
local lspconfig = require('lspconfig')

-- Common LSP settings
local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Common capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Export for use by language-specific configs
return {
  on_attach = on_attach,
  capabilities = capabilities,
}
```

### Language Extension Pattern
Language-specific containers append to `plugins.lua`:

```dockerfile
# In language-specific Dockerfile
RUN echo '\n-- Python-specific configurations\nrequire("config.lsp-python")\nrequire("config.treesitter-python")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua
```

**Language Configuration Example** - `config/lsp-python.lua`:
```lua
-- Python-specific LSP configuration
local lspconfig = require('lspconfig')
local base = require('config.lsp-base')

lspconfig.pylsp.setup {
  on_attach = base.on_attach,
  capabilities = base.capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = true },
      }
    }
  }
}
```

## tmux Configuration Pattern

### Base Configuration
**File**: `.config/tmux/tmux.conf`

```bash
# Change prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Vim-like pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Enable mouse mode
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Reload config file
bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

# Status bar configuration
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
```

### Language-Specific Window Layouts
Each container creates predefined windows via entrypoint scripts:

**Base Layout**:
```bash
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "shell"
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "claude"
```

**Python Layout**:
```bash
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "python"
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "test"
tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "claude"
```

## Shell Configuration (Zsh)

### Oh-My-Zsh Setup
**File**: `.config/zsh/.zshrc`

```bash
# Set up Oh-My-Zsh
export ZSH="$ZDOTDIR/ohmyzsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Powerlevel10k configuration
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias vi='nvim'

# Development shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Language-specific aliases added by containers
# Python: alias python='python3', alias pip='pip3'
# .NET: alias dn='dotnet', alias dnr='dotnet run', alias dnt='dotnet test'
```

## Environment Validation Pattern

### Entrypoint Script Template
All containers use this validation pattern:

```bash
#!/bin/bash

# Get username
USERNAME=$(whoami)
echo "Running as user: $USERNAME"

# Validate PROJECT_NAME environment variable
if [ -z "$PROJECT_NAME" ]; then
    echo "ERROR: PROJECT_NAME environment variable is not set"
    exit 1
fi

PROJECT_DIR="/src/$PROJECT_NAME"
echo "Using project directory: $PROJECT_DIR"

# Validate project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory $PROJECT_DIR does not exist"
    exit 1
fi

# Container-specific tmux session setup
# (implemented in each container's entrypoint)

# Attach to session
exec tmux attach-session -t dev
```

## Build Configuration Patterns

### Multi-Stage Dockerfile Pattern
```dockerfile
FROM devastation/base:latest

# Install language-specific tools
RUN apt-get update && apt-get install -y \
    language-runtime \
    language-tools \
    && rm -rf /var/lib/apt/lists/*

# Copy language-specific configurations
COPY ./.config /home/$USERNAME/.config/

# Extend Neovim configuration
RUN echo '\n-- Language-specific configurations' >> /home/$USERNAME/.config/nvim/lua/plugins.lua && \
    echo 'require("config.lsp-language")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua && \
    echo 'require("config.treesitter-language")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua

# Install language-specific Treesitter parsers
RUN nvim --headless "+TSInstall language" +qa

# Use language-specific entrypoint
ENTRYPOINT ["/usr/local/bin/language-entrypoint.sh"]
```

### Configuration File Copying
```dockerfile
# Copy entire config directory structure
COPY ./.config /home/$USERNAME/.config/

# Ensure proper ownership
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/
```

## Key Binding Conventions

### Neovim Leader Key Mappings
- **Leader Key**: `<Space>` (consistent across all containers)
- **File Operations**: `<leader>e` (explorer), `<leader>ff` (find files)
- **Search**: `<leader>fg` (live grep), `<leader>fb` (buffers)
- **LSP**: `<leader>rn` (rename), `<leader>ca` (code action)
- **Debug**: `<leader>db` (breakpoint), `<leader>dc` (continue)

### tmux Prefix Key Mappings
- **Prefix Key**: `C-a` (consistent across all containers)
- **Split**: `prefix |` (horizontal), `prefix -` (vertical)
- **Navigate**: `prefix h/j/k/l` (vim-like movement)
- **Reload**: `prefix r` (reload configuration)

## Extension Guidelines

### Adding New Language Support
1. **Create language-specific configuration files**:
   - `config/lsp-language.lua`
   - `config/treesitter-language.lua`
   - `config/dap-language.lua` (if debugging supported)

2. **Extend plugins.lua in Dockerfile**:
   ```dockerfile
   RUN echo 'require("config.lsp-newlang")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua
   ```

3. **Create custom entrypoint script**:
   - Follow validation pattern
   - Create language-appropriate tmux windows
   - Include helpful startup commands

4. **Install Treesitter parsers**:
   ```dockerfile
   RUN nvim --headless "+TSInstall newlang" +qa
   ```

### Configuration Override Pattern
Users can override any configuration by mounting custom config files:

```bash
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ./my-nvim-config:/home/dev/.config/nvim \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/python:latest
```

This pattern allows complete customization while maintaining base functionality.