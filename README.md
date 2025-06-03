# Devastation

<p align="center">
  <img src="assets/devastation_logo.png" alt="Devastation Logo" width="300">
</p>

**Instant development environments in Docker containers.**

Devastation provides pre-configured development containers with Neovim, tmux, and language-specific tooling. No more "works on my machine" – get a consistent, powerful development environment anywhere Docker runs.

## What You Get

🚀 **Base Environment**: Ubuntu 22.04 + Zsh + Neovim + tmux  
🐍 **Python**: Python 3.11 + LSP + debugging + pytest  
⚡ **C#/.NET**: .NET 8 SDK + OmniSharp + debugging  
☸️  **DevOps**: AWS CLI + kubectl + Terraform + Helm  

## Quick Start

```bash
# Python development
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/python:latest

# .NET development  
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/dotnet:latest

# Infrastructure/DevOps
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.aws:/home/dev/.aws \
  -v ~/.kube:/home/dev/.kube \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/cluster:latest
```

## Available Containers

| Container | Purpose | Key Tools |
|-----------|---------|-----------|
| `devastation/base` | Foundation for all containers | Neovim, tmux, Zsh, Node.js, Claude Code |
| `devastation/python` | Python development | Python 3.11, Poetry, pytest, python-lsp-server |
| `devastation/dotnet` | .NET development | .NET 8 SDK, OmniSharp, Azure CLI integration |
| `devastation/cluster` | Infrastructure & DevOps | AWS CLI, kubectl, Terraform, Helm |

## Building Containers

```bash
# Build all containers
make all

# Build specific containers
make base
make python
make dotnet  
make cluster

# Custom username (defaults to 'dev')
make USERNAME=$(whoami) base
```

## What's Inside

### Every Container Includes
- **Neovim**: Fully configured with LSP, completion, debugging, file explorer
- **tmux**: Multi-window terminal with intuitive key bindings
- **Zsh**: Oh-My-Zsh + Powerlevel10k theme + useful plugins
- **Development Tools**: Git, ripgrep, fd, tree, curl
- **Claude Code**: AI assistant CLI for development help

### tmux Layout
Each container starts with pre-configured tmux windows:
- **Window 1**: Main development shell  
- **Window 2**: Neovim editor
- **Window 3+**: Language/tool-specific windows
- **Final Window**: Claude Code assistant

### Key Bindings
- **tmux prefix**: `Ctrl+a`
- **Neovim leader**: `Space`
- **Split tmux**: `Ctrl+a |` (horizontal), `Ctrl+a -` (vertical)
- **Find files**: `Space + ff`
- **Live grep**: `Space + fg`

## Customization

### Persistent Configuration
Mount config directories to persist settings across container runs:

```bash
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.config/claude:/home/dev/.config/claude \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/python:latest
```

### Custom Neovim Config
Override the entire Neovim configuration:

```bash
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.config/nvim:/home/dev/.config/nvim \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/base:latest
```

### Extending Containers
Create your own specialized container:

```dockerfile
FROM devastation/python:latest

# Add your tools
RUN pip install mypy black isort

# Add your configurations
COPY my-configs/ /home/dev/.config/
```

## Requirements

- **Docker**: Latest version recommended
- **Environment Variable**: `PROJECT_NAME` must be set
- **Project Mount**: Your project must be mounted to `/src/$PROJECT_NAME`

The containers validate these requirements and fail with clear error messages if not met.

## Architecture

```
devastation/base:latest
├── devastation/python:latest    (Python + base tools)
├── devastation/dotnet:latest    (.NET + base tools)  
└── devastation/cluster:latest   (DevOps + base tools)
```

Each language container extends the base with specialized tools and configurations while maintaining the same core development experience.

## Documentation

- **User Guides**: See individual container README files
- **Development**: See `claude/` directory for detailed technical documentation
- **Customization**: See `claude/configuration_patterns.md`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Test your changes with the target container
4. Submit a pull request

See `claude/development_workflow.md` for detailed contributor guidelines.

---

**Ready to devastate your development workflow?** 🚀

Pick a container and start coding with zero configuration time.