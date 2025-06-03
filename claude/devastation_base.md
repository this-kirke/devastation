# Base Devastation Container

## Purpose

The base devastation provides the foundation development environment with essential tools, editor configuration, and terminal setup that all language-specific containers extend.

## Container Specifications

**Base Image**: `ubuntu:22.04`
**Default User**: `dev` (UID: 1000, GID: 1000)
**Working Directory**: Set at runtime via `-w` or `working_dir`

## Installed Software

### System Packages
```bash
curl fd-find fontconfig gcc git locales make ripgrep plantuml sudo tree tmux unzip zsh
```

### Development Tools
- **Node.js 20**: JavaScript runtime and package ecosystem
- **Neovim**: Latest version with plugin ecosystem
- **Meslo Nerd Font**: Terminal font with icon support
- **Claude Code CLI**: AI assistant for development
- **Atuin**: Shell history manager with sync capabilities

### Shell Environment
- **Zsh**: Default shell with Oh-My-Zsh framework
- **Powerlevel10k**: Fast, customizable prompt theme
- **Plugins**: autosuggestions, syntax-highlighting
- **XDG Configuration**: `ZDOTDIR=/home/$USERNAME/.config/zsh`

## Neovim Configuration

### Plugin Manager
**Lazy.nvim**: Modern plugin manager with lazy loading

### Core Plugins
- **Colorscheme**: Solarized Dark for consistent theming
- **Neo-tree**: File explorer with git integration
- **Telescope**: Fuzzy finder for files, text, symbols
- **LSP**: Language Server Protocol client
- **nvim-cmp**: Completion engine with multiple sources
- **Treesitter**: Syntax highlighting and code understanding
- **Lualine**: Status line with git and LSP information
- **Gitsigns**: Git integration in editor
- **DAP**: Debug Adapter Protocol for debugging

### Configuration Structure
```
.config/nvim/
├── init.lua                    # Entry point, basic settings
├── lua/
    ├── plugins.lua            # Plugin definitions with Lazy.nvim
    └── config/                # Individual plugin configurations
        ├── colorscheme.lua    # Theme setup
        ├── neo-tree.lua       # File explorer config
        ├── telescope.lua      # Fuzzy finder setup
        ├── lsp-base.lua       # Base LSP configuration
        ├── cmp.lua           # Completion setup
        ├── treesitter-base.lua # Base syntax highlighting
        ├── lualine.lua       # Status line config
        ├── gitsigns.lua      # Git integration
        └── dap-base.lua      # Base debugging setup
```

### Key Bindings
- **Leader Key**: `<Space>`
- **File Explorer**: `<leader>e` (toggle Neo-tree)
- **Find Files**: `<leader>ff` (Telescope)
- **Live Grep**: `<leader>fg` (Telescope)
- **Find Buffers**: `<leader>fb` (Telescope)

## tmux Configuration

### Key Bindings
- **Prefix**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Split Horizontal**: `prefix |`
- **Split Vertical**: `prefix -`
- **Navigate Panes**: `prefix h/j/k/l`
- **Reload Config**: `prefix r`

### Default Windows
1. **shell**: Main development shell in project directory
2. **editor**: Neovim session for code editing
3. **claude**: Claude Code assistant for AI help

## Environment Configuration

### Required Variables
- `PROJECT_NAME`: Project identifier for directory structure

### NPM Configuration
- **Global Prefix**: `/home/$USERNAME/.config/npm/global`
- **Cache**: `/home/$USERNAME/.config/npm/cache`
- **Config**: `/home/$USERNAME/.config/npm/npmrc`
- **Claude Code**: Pre-installed globally

### Path Setup
- NPM global binaries in PATH
- Local tools prioritized over system tools

## Entrypoint Behavior

### Validation Steps
1. Check `PROJECT_NAME` environment variable is set
2. Verify `/src/$PROJECT_NAME` directory exists
3. Fail with clear error message if validation fails

### tmux Session Setup
1. Create session named `dev` in project directory
2. Create `shell` window (main development)
3. Create `editor` window with Neovim
4. Create `claude` window with Claude Code
5. Select first window and attach session

### Error Handling
- Exit code 1 with descriptive error messages
- Clear indication of missing requirements
- No partial startup - fail completely if environment invalid

## Extension Pattern for Language Containers

### Dockerfile Pattern
```dockerfile
FROM devastation/base:latest

# Install language-specific tools
RUN apt-get update && apt-get install -y language-tools

# Add language-specific Neovim configuration
RUN echo 'require("config.lsp-language")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua

# Install language-specific Treesitter parsers
RUN nvim --headless "+TSInstall language" +qa

# Use custom entrypoint for language-specific windows
ENTRYPOINT ["/usr/local/bin/language-entrypoint.sh"]
```

### Configuration Extension
- Copy base configuration files
- Append language-specific imports to `plugins.lua`
- Install language Treesitter parsers
- Configure language servers in separate config files

## Build Customization

### Build Arguments
- `USERNAME`: Container username (default: dev)
- `USER_UID`: User ID (default: 1000)
- `USER_GID`: Group ID (default: 1000)

### Custom User Build
```bash
docker buildx build --build-arg USERNAME=$(whoami) -t devastation/base:latest ./base
```

## Development Workflow

### Plugin Development
1. Edit configurations in `.config/nvim/lua/config/`
2. Test with `:Lazy reload` or restart Neovim
3. Run headless plugin sync: `nvim --headless "+Lazy! sync" +qa`

### Container Testing
```bash
# Test Neovim works
docker run -it --rm devastation/base:latest zsh -c "nvim --version"

# Test plugins load
docker run -it --rm devastation/base:latest zsh -c "nvim --headless '+Lazy check' +qa"
```

## Volume Mount Strategy

### Development Mounts
```bash
-v $(pwd):/src/MyProject              # Project source code
-v ~/.config/claude:/home/dev/.config/claude  # Claude authentication
-v ~/.config/git:/home/dev/.config/git        # Git configuration
```

### Why This Pattern
- **Project Isolation**: Each project in separate `/src/` directory
- **Claude Permissions**: Prevents permission leakage between projects
- **Configuration Persistence**: Shell history, git config, claude auth persist
- **Clean Separation**: Project code separate from user configuration