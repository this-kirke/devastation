# Devastation

A collection of specialized Docker development environments built on a common base.

## Project Goal

This project provides a set of Docker containers ("devastations") that create consistent, pre-configured development environments for various programming languages and operational tasks. Each container comes with a powerful terminal setup and a fully configured Neovim development environment, eliminating the need to manually configure development tools across different machines or projects.

## Architecture

The project follows a layered container architecture:

```
                               ┌─────────────┐
                               │   Base Dev  │
                               │ Devastation │
                               └──────┬──────┘
                                      │
         ┌─────────┬─────────┬────────┼────────┬─────────┬─────────┐
         │         │         │        │        │         │         │
┌────────▼───┐ ┌───▼─────┐ ┌─▼──────┐ │ ┌──────▼───┐ ┌───▼─────┐ ┌─▼───────┐
│    .NET    │ │   Go    │ │ Python │ │ │   Rust   │ │   Zig   │ │ DevOps/ │
│ Container  │ │ Container│ │Container│ │ │ Container│ │Container│ │   K8s   │
└────────────┘ └─────────┘ └────────┘ │ └──────────┘ └─────────┘ └─────────┘
                                      │
```

### Base Development Container

The base container (`base-devastation`) includes:

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

### Language-Specific Containers

Each language container extends the base image with:

1. **Language runtime/SDK**
2. **Language-specific tools**:
   - Linters
   - Formatters 
   - Package managers
3. **Neovim configuration**:
   - Language server integration
   - Treesitter parser
   - DAP configuration

Language devastations include:
- **.NET**: Latest .NET SDK and runtime
- **Python**: Python 3 with poetry and common data science packages
- **Cluster**: Kubernetes and cloud infrastructure tools

## Usage

### Single Container

Each devastation can be used as a development environment either:
1. Directly with Docker: `docker run -it --rm -v $(pwd):/project devastation/dotnet:latest`
2. Via VS Code's Dev Containers extension
3. As a base for custom Dockerfiles

### Docker Compose Setup

For multi-container development, a docker-compose.yml file is provided:

```bash
# Start the development environment with PostgreSQL database
docker-compose up -d

# Connect to the container
docker-compose exec dotnet bash
```

This will start both the dotnet container and a PostgreSQL database for local development.

## Directory Structure

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