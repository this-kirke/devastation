# Devastation

A collection of specialized Docker development environments built on a common base.

## project goal

This project provides a set of Docker containers ("devastations") that create consistent, pre-configured development environments for various programming languages and operational tasks. Each container comes with a powerful terminal setup and a fully configured Neovim development environment, eliminating the need to manually configure development tools across different machines or projects.

## architecture

The project follows a layered container architecture:

![Devastation Architecture](architecture.svg)

### base devastation

The base devastation includes:

- Ubuntu 22.04 LTS
- zsh with Oh-My-Zsh and Powerlevel10k theme
- Meslo Nerd Font
- Neovim with the following plugins:
  - Lazy (plugin manager)
  - Solarized Dark color scheme
  - Neo-tree (file browser)
  - Telescope (fuzzy finder)
  - LSP configuration
  - nvim-cmp (completion)
  - Lualine (status line)
  - Treesitter (syntax highlighting)
  - Gitsigns (git integration)
  - DAP (Debug Adapter Protocol) support
- tmux (terminal multiplexer)

### language-specific devastations

Each language devastation extends the base image with:

1. **Language runtime/SDK**
2. **Language-specific tools**:
   - Linters
   - Formatters 
   - Package managers
3. **Neovim configuration**:
   - Language server integration
   - Treesitter parser
   - DAP configuration

language devastations include:
- **.NET**: Latest .NET SDK and runtime
- **Python**: Python 3 with poetry and common data science packages
- **Cluster**: Kubernetes and cloud infrastructure tools

## Usage

### devastation usage

Each devastation can be used as a development environment either:
1. Directly with Docker: `docker run -it --rm -v $(pwd):/project devastation/dotnet:latest`
2. As a base for custom Dockerfiles

## directory structure

```
devastation/
├── base/           # Base development container
├── cluster/        # Kubernetes/DevOps development container
├── dotnet/         # .NET development container
├── python/         # Python development container
├── rust/           # Rust development container (planned)
├── zig/            # Zig development container (planned)
└── go/             # Go development container (planned)
```