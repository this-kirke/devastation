# Base Devastation

The foundation container that all other devastation containers extend. Provides a complete development environment with Neovim, tmux, and essential development tools.

## Purpose

This container serves as the base layer for all language-specific devastations. It includes everything needed for general development work and provides the foundation that other containers build upon.

## What's Included

### Core Development Tools
- **Ubuntu 22.04 LTS**: Stable base operating system
- **Zsh**: Default shell with Oh-My-Zsh framework
- **Powerlevel10k**: Fast, customizable prompt theme
- **tmux**: Terminal multiplexer with intuitive key bindings
- **Neovim**: Latest version with comprehensive plugin setup
- **Node.js 20**: JavaScript runtime (also powers Claude Code)

### Development Utilities
- **Git**: Version control
- **ripgrep**: Fast text search
- **fd**: Fast file finder
- **tree**: Directory structure visualization
- **curl**: HTTP client
- **Claude Code**: AI assistant CLI

### Neovim Configuration
- **Lazy.nvim**: Modern plugin manager
- **Neo-tree**: File explorer with git integration
- **Telescope**: Fuzzy finder for files and text
- **LSP**: Language Server Protocol client
- **nvim-cmp**: Intelligent completion
- **Treesitter**: Advanced syntax highlighting
- **Lualine**: Status line with git and LSP info
- **Gitsigns**: Git changes in the gutter
- **DAP**: Debug Adapter Protocol support

## Building

```bash
# Build with default settings
make base

# Build with your username instead of 'dev'
make USERNAME=$(whoami) base

# Direct Docker build
docker buildx build -t devastation/base:latest ./base
```

## Usage

### Basic Usage
```bash
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/base:latest
```

### With Persistent Configuration
```bash
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.config/claude:/home/dev/.config/claude \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/base:latest
```

## tmux Windows

The container starts with three tmux windows:

1. **shell**: Main development shell in your project directory
2. **editor**: Neovim ready for editing
3. **claude**: Claude Code assistant for AI help

Navigate between windows with `Ctrl+a 1`, `Ctrl+a 2`, `Ctrl+a 3`.

## Key Bindings

### tmux
- **Prefix**: `Ctrl+a`
- **Split horizontal**: `Ctrl+a |`
- **Split vertical**: `Ctrl+a -`
- **Navigate panes**: `Ctrl+a h/j/k/l`
- **New window**: `Ctrl+a c`

### Neovim
- **Leader key**: `Space`
- **File explorer**: `Space + e`
- **Find files**: `Space + ff`
- **Live grep**: `Space + fg`
- **Find buffers**: `Space + fb`

## Customization

### Override Neovim Config
```bash
# Mount your own Neovim configuration
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.config/nvim:/home/dev/.config/nvim \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/base:latest
```

### Add Tools via Dockerfile
```dockerfile
FROM devastation/base:latest

# Install additional tools
RUN apt-get update && apt-get install -y \
    your-favorite-tool \
    another-tool \
    && rm -rf /var/lib/apt/lists/*

# Copy custom configurations
COPY my-configs/ /home/dev/.config/
```

### Build Arguments
- `USERNAME`: Container username (default: `dev`)
- `USER_UID`: User ID (default: `1000`)
- `USER_GID`: Group ID (default: `1000`)

```bash
docker buildx build \
  --build-arg USERNAME=$(whoami) \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) \
  -t devastation/base:latest ./base
```

## Using as Base Image

This container is designed to be extended by language-specific containers:

```dockerfile
FROM devastation/base:latest

# Install your language runtime
RUN apt-get update && apt-get install -y python3.11

# Add language-specific Neovim config
RUN echo 'require("config.lsp-python")' >> /home/dev/.config/nvim/lua/plugins.lua

# Install language tools
RUN pip install python-lsp-server

ENTRYPOINT ["/usr/local/bin/python-entrypoint.sh"]
```

## Requirements

- `PROJECT_NAME` environment variable must be set
- Project must be mounted to `/src/$PROJECT_NAME`
- Container validates these requirements on startup

If requirements aren't met, the container will exit with a clear error message.

## Font Support

The container includes Meslo Nerd Font for terminal icons and symbols. For the best experience, configure your terminal to use a Nerd Font or ensure your terminal supports the Unicode symbols used by the prompt and file explorer.