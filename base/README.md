# Base Devastation Container

This is the base development environment container for the Devastation project. It provides a powerful, pre-configured terminal setup with Zsh, Oh-My-Zsh, Powerlevel10k, Neovim, and tmux.

## Features

- Ubuntu 22.04 LTS base
- Zsh with Powerlevel10k theme and useful plugins
- Meslo Nerd Font for rich terminal symbols
- Neovim with a curated set of plugins:
  - Lazy.nvim (plugin manager)
  - Solarized Dark color scheme
  - Neo-tree (file browser)
  - Telescope (fuzzy finder)
  - LSP configuration
  - Completion (nvim-cmp)
  - Treesitter (syntax highlighting)
  - Lualine (status line)
  - Gitsigns (git integration)
  - DAP (Debug Adapter Protocol)
- tmux with sane defaults and intuitive keybindings

## Usage

### Building the Image

From the project root directory:

```bash
# Build with default username (dev)
docker buildx build -t devastation/base:latest ./base

# Or build with your current username
docker buildx build --build-arg USERNAME=$(whoami) -t devastation/base:latest ./base
```

You can customize the user in the container by passing build arguments:
- `USERNAME`: The username for the container user (default: dev)
- `USER_UID`: The user ID for the container user (default: 1000)
- `USER_GID`: The group ID for the container user (default: 1000)

### Running the Container

```bash
docker run -it --rm devastation/base:latest
```

### Using as a Base Image

This container is designed to be extended by language-specific containers. In your Dockerfile:

```dockerfile
FROM devastation/base:latest

# Add language-specific tools and configurations
```

## Configuration Structure

### Zsh Configuration

- `.zshrc` - Main Zsh configuration
- `.p10k.zsh` - Powerlevel10k theme configuration

### Neovim Configuration

The Neovim setup follows a modular structure:

```
nvim/
├── init.lua             # Main entry point with basic settings
├── lua/
    ├── plugins.lua      # Plugin definitions using lazy.nvim
    └── config/          # Individual plugin configurations
        ├── colorscheme.lua
        ├── neo-tree.lua
        ├── telescope.lua
        ├── lsp.lua
        ├── cmp.lua
        ├── treesitter.lua
        ├── lualine.lua
        ├── gitsigns.lua
        └── dap.lua
```

### tmux Configuration

- `.tmux.conf` - tmux configuration with intuitive keybindings

## Key Bindings

### Neovim Key Bindings

- `<Space>` - Leader key
- `<leader>e` - Toggle file explorer (Neo-tree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find open buffers (Telescope)

Full key binding documentation can be found in the respective plugin configuration files.

### tmux Key Bindings

- `Ctrl+a` - Prefix key (default is `Ctrl+b`)
- `prefix |` - Split window horizontally
- `prefix -` - Split window vertically
- `prefix h/j/k/l` - Navigate between panes
- `prefix r` - Reload tmux configuration

## Extending

This base container is designed to be extended. Language-specific containers should:

1. Install language-specific tools
2. Configure language servers in Neovim
3. Set up language-specific debugging
4. Add any custom configurations needed

## Customization

To customize your own container based on this image:

1. Create a new Dockerfile that uses this as the base image
2. Mount your own configuration files
3. Install additional tools as needed

Example:

```dockerfile
FROM devastation/base:latest

# Copy custom configurations
COPY my-configs/.zshrc /home/dev/.zshrc
COPY my-configs/nvim /home/dev/.config/nvim/

# Install additional tools
RUN apt-get update && apt-get install -y your-package
```