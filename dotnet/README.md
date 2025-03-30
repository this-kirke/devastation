# .NET Devastation

A Docker-based development environment for .NET applications.

## Features

- Ubuntu 22.04 base with full development toolset
- .NET SDK 8.0
- Azure Artifacts Credential Provider for NuGet package management
- Neovim with language-specific plugins:
  - OmniSharp Language Server for C# intellisense and code navigation
  - Treesitter for advanced syntax highlighting
  - Debug Adapter Protocol (DAP) for debugging .NET applications
- Pre-configured tmux session with development windows

## Usage

Build the image:

```bash
make dotnet
```

Run the container:

```bash
docker run -it --rm -v $(pwd):/project devastation/dotnet:latest
```

This will start a tmux session with:
- Main dotnet shell
- Neovim editor
- Test window

## Development Workflow

Inside the container:

1. `dotnet new` commands create new projects
2. Neovim provides full IDE features with OmniSharp
3. Debug using Neovim's DAP integration
4. Run tests with `dotnet test`