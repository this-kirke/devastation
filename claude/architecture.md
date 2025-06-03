# Devastation Container Architecture

## Overview

Devastation uses a layered Docker architecture where a base container provides common development tools, and language-specific containers extend it with specialized tooling.

## Container Hierarchy

```
devastation/base:latest
├── devastation/python:latest    (extends base)
├── devastation/dotnet:latest    (extends base)
└── devastation/cluster:latest   (extends base)
```

## Base Container Foundation

**Base Image**: Ubuntu 22.04 LTS

**Core Development Stack**:
- **Shell**: Zsh + Oh-My-Zsh + Powerlevel10k theme
- **Terminal Multiplexer**: tmux with intuitive keybindings
- **Editor**: Neovim with LSP, completion, debugging support
- **Font**: Meslo Nerd Font for terminal symbols
- **History**: Atuin shell history manager
- **Node.js**: Version 20 (for Claude Code and tooling)
- **Claude Code**: AI assistant CLI pre-installed

## Directory Structure Pattern

All containers follow XDG Base Directory specification:

```
/home/$USERNAME/.config/
├── zsh/                 # Zsh configuration (ZDOTDIR)
├── tmux/               # tmux configuration  
├── nvim/               # Neovim configuration
│   ├── init.lua        # Entry point
│   ├── lua/plugins.lua # Plugin definitions
│   └── lua/config/     # Plugin configurations
├── claude/             # Claude Code authentication
└── git/                # Git configuration
```

## Language Extension Pattern

Each language container:

1. **Installs Language Runtime**: Python 3.11, .NET 8, AWS CLI, etc.
2. **Adds Language Tools**: Package managers, linters, formatters
3. **Configures Neovim**: LSP servers, Treesitter parsers, DAP adapters
4. **Customizes tmux**: Language-specific window layouts

## Project Mounting Strategy

**Current Pattern** (post-modernization):
```bash
# Mount project to /src/$PROJECT_NAME
-v $(pwd):/src/MyProject
-w /src/MyProject
-e PROJECT_NAME=MyProject
```

**Critical Requirements**:
- `PROJECT_NAME` environment variable MUST be set
- Project directory `/src/$PROJECT_NAME` MUST exist and be mounted
- Containers fail-fast (exit 1) if requirements not met

**Benefits**:
- Claude Code permissions isolation between projects
- Consistent project paths across all containers
- Clear separation of concerns

## Entrypoint Behavior

All containers use similar entrypoint pattern:

1. **Validate Environment**: Check `PROJECT_NAME` is set
2. **Validate Directory**: Ensure `/src/$PROJECT_NAME` exists
3. **Set Project Directory**: `PROJECT_DIR="/src/$PROJECT_NAME"`
4. **Start tmux Session**: Create session with project as working directory
5. **Create Windows**: Language-specific tmux windows
6. **Attach Session**: Drop user into development environment

## Network and Volume Strategy

**Development Pattern**:
- Single bind mount: entire project to `/src/$PROJECT_NAME`
- Configuration persistence via additional mounts (Claude, Git configs)
- No complex volume management needed
- Services communicate via docker-compose networks when needed

## Build Architecture

**Base First**: Base container built independently
**Extensions**: Language containers `FROM devastation/base:latest`
**No Cross-Dependencies**: Each language container is independent
**Build Args**: `USERNAME`, `USER_UID`, `USER_GID` for user customization

## tmux Window Layouts

**Base Container**:
1. `shell` - Main development shell
2. `editor` - Neovim session
3. `claude` - Claude Code assistant

**Python Extension**:
1. `python` - Python REPL and development
2. `editor` - Neovim with Python LSP
3. `test` - Testing environment
4. `claude` - AI assistant

**Dotnet Extension**:
1. `dotnet` - .NET CLI and development
2. `editor` - Neovim with C# LSP
3. `test` - Testing with dotnet test
4. `claude` - AI assistant

**Cluster Extension**:
1. `cluster` - Main infrastructure shell
2. `editor` - Neovim with YAML/HCL LSP
3. `aws` - AWS CLI operations
4. `terraform` - Infrastructure as Code
5. `kubectl` - Kubernetes management
6. `claude` - AI assistant