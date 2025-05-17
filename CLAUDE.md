# Devastation Development Environment

## Project Overview

Devastation is a collection of Docker-based development environments built on a layered architecture. It provides pre-configured containers with Neovim, tmux, and language-specific tooling for consistent development experiences across projects.

## Quick Start for Claude Code

When working on Devastation:

1. **Project Structure**: Base container + language-specific extensions
2. **Container Mounting**: Projects mount to `/src/$PROJECT_NAME` with `PROJECT_NAME` env var required
3. **Configuration**: XDG-compliant configs in `.config/` directories
4. **Entry Point**: All containers start tmux sessions with pre-configured windows

## Key Commands

```bash
# Build containers
make base              # Base development environment
make python           # Python + base
make dotnet           # .NET + base  
make cluster          # Kubernetes/DevOps + base

# Run containers (new pattern)
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/base:latest
```

## Documentation Structure

- `claude/architecture.md` - Container architecture and relationships
- `claude/devastation_base.md` - Base container internals and configuration
- `claude/devastation_python.md` - Python-specific extensions
- `claude/devastation_dotnet.md` - .NET-specific extensions  
- `claude/devastation_cluster.md` - Kubernetes/DevOps tooling
- `claude/configuration_patterns.md` - Neovim, tmux, and shell configuration conventions
- `claude/development_workflow.md` - How to develop and extend devastation containers

## Code Style Guidelines

- **Indentation**: 2 spaces (Lua), 4 spaces (other languages)
- **Line Length**: 80 characters maximum
- **Naming**: camelCase (variables/functions), PascalCase (classes/types)
- **Docker**: Multi-line RUN with backslash continuation, grouped commands
- **Commits**: Conventional commits (feat/fix/docs/chore/refactor)
- **Error Handling**: Use pcall/xpcall for Lua, fail-fast for shell scripts

## Critical Implementation Details

- **Project Directory**: `/src/$PROJECT_NAME` (not `/home/$USERNAME/project`)
- **Environment Validation**: Containers exit(1) if `PROJECT_NAME` unset or directory missing
- **Working Directory**: Set at runtime via docker-compose `working_dir`, not Dockerfile `WORKDIR`
- **Entrypoint Pattern**: All entrypoints validate environment and start tmux sessions
