# Devastation Development Workflow

## Overview

This document outlines the development workflow for extending, maintaining, and contributing to the devastation container ecosystem. It covers both user workflows and contributor workflows.

## Contributor Development Workflow

### Setting Up Development Environment

1. **Clone Repository**:
   ```bash
   git clone <devastation-repo>
   cd devastation
   ```

2. **Build Base Container**:
   ```bash
   make base
   # Or with custom username
   make USERNAME=$(whoami) base
   ```

3. **Test Base Container**:
   ```bash
   docker run -it --rm \
     -v $(pwd):/src/devastation \
     -w /src/devastation \
     -e PROJECT_NAME=devastation \
     devastation/base:latest
   ```

### Development Iteration Cycle

#### 1. Configuration Development
**For Neovim plugin configurations**:

```bash
# Edit configuration files
vim base/.config/nvim/lua/config/telescope.lua

# Test configuration interactively
docker run -it --rm \
  -v $(pwd)/base/.config:/home/dev/.config \
  -v $(pwd):/src/devastation \
  -w /src/devastation \
  -e PROJECT_NAME=devastation \
  devastation/base:latest

# Inside container, test changes
nvim  # Test the configuration
:Lazy reload  # Reload plugins if needed
```

**For tmux configurations**:
```bash
# Edit tmux config
vim base/.config/tmux/tmux.conf

# Test in running container
tmux source-file ~/.config/tmux/tmux.conf
```

#### 2. Dockerfile Development
**Iterative container building**:

```bash
# Build specific container
docker buildx build -t devastation/python:latest ./python

# Test container functionality
docker run -it --rm \
  -v $(pwd):/src/devastation \
  -w /src/devastation \
  -e PROJECT_NAME=devastation \
  devastation/python:latest

# Test specific functionality
docker run -it --rm devastation/python:latest zsh -c "python --version"
docker run -it --rm devastation/python:latest zsh -c "nvim --headless '+Lazy check' +qa"
```

#### 3. Language Extension Development
**Creating new language support**:

1. **Create language directory structure**:
   ```bash
   mkdir -p newlang/.config/nvim/lua/config
   mkdir -p newlang/.config
   ```

2. **Copy base configurations**:
   ```bash
   cp -r base/.config/* newlang/.config/
   ```

3. **Create language-specific configurations**:
   ```bash
   # LSP configuration
   cat > newlang/.config/nvim/lua/config/lsp-newlang.lua << 'EOF'
   local lspconfig = require('lspconfig')
   local base = require('config.lsp-base')
   
   lspconfig.newlang_ls.setup {
     on_attach = base.on_attach,
     capabilities = base.capabilities,
   }
   EOF
   ```

4. **Create Dockerfile**:
   ```dockerfile
   FROM devastation/base:latest
   
   # Install language runtime
   RUN apt-get update && apt-get install -y newlang-runtime
   
   # Copy configurations
   COPY ./.config /home/$USERNAME/.config/
   
   # Extend Neovim configuration
   RUN echo 'require("config.lsp-newlang")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua
   
   # Install Treesitter parser
   RUN nvim --headless "+TSInstall newlang" +qa
   
   ENTRYPOINT ["/usr/local/bin/newlang-entrypoint.sh"]
   ```

5. **Create entrypoint script**:
   ```bash
   cp base/entrypoint.sh newlang/entrypoint.sh
   # Modify tmux window creation for language-specific layout
   ```

### Testing Workflows

#### Automated Testing
**Plugin functionality testing**:
```bash
# Test Neovim starts without errors
docker run --rm devastation/base:latest zsh -c "nvim --headless +qa"

# Test plugins load successfully
docker run --rm devastation/base:latest zsh -c "nvim --headless '+Lazy check' +qa"

# Test LSP server availability
docker run --rm devastation/python:latest zsh -c "python -m pylsp --help"

# Test Treesitter parsers installed
docker run --rm devastation/python:latest zsh -c "nvim --headless '+TSInstallInfo' +qa"
```

#### Manual Testing Scenarios
**User experience testing**:

1. **Project Development Simulation**:
   ```bash
   # Create test project
   mkdir test-project
   cd test-project
   
   # Initialize project files
   echo 'print("Hello, World!")' > main.py
   echo '# Test Project' > README.md
   
   # Test container with project
   docker run -it --rm \
     -v $(pwd):/src/test-project \
     -w /src/test-project \
     -e PROJECT_NAME=test-project \
     devastation/python:latest
   ```

2. **Configuration Persistence Testing**:
   ```bash
   # Test git config persistence
   mkdir -p ~/.config/git
   echo '[user]\n  name = Test User\n  email = test@example.com' > ~/.config/git/config
   
   docker run -it --rm \
     -v $(pwd):/src/test-project \
     -v ~/.config/git:/home/dev/.config/git \
     -w /src/test-project \
     -e PROJECT_NAME=test-project \
     devastation/base:latest
   
   # Inside container: git config --list should show user settings
   ```

3. **Error Handling Testing**:
   ```bash
   # Test missing PROJECT_NAME
   docker run -it --rm devastation/base:latest
   # Should exit with clear error message
   
   # Test missing project directory
   docker run -it --rm \
     -e PROJECT_NAME=nonexistent \
     devastation/base:latest
   # Should exit with clear error message
   ```

### Code Quality Standards

#### Dockerfile Best Practices
```dockerfile
# Use specific versions when possible
FROM ubuntu:22.04

# Group related commands to reduce layers
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    package3 \
    && rm -rf /var/lib/apt/lists/*

# Use continuation backslashes for readability
RUN curl -fsSL https://example.com/install.sh | bash && \
    chmod +x /usr/local/bin/tool && \
    tool --version

# Set ownership explicitly
COPY --chown=$USERNAME:$USERNAME ./.config /home/$USERNAME/.config/
```

#### Lua Configuration Standards
```lua
-- Use consistent indentation (2 spaces)
-- Group external dependencies, then internal
local external_plugin = require('external_plugin')
local internal_config = require('config.internal')

-- Use descriptive variable names
local completion_sources = {
  { name = 'nvim_lsp' },
  { name = 'buffer' },
}

-- Include error handling for optional dependencies
local ok, telescope = pcall(require, 'telescope')
if not ok then
  vim.notify("Telescope not available", vim.log.levels.WARN)
  return
end
```

#### Shell Script Standards
```bash
#!/bin/bash

# Fail on any error
set -e

# Use descriptive variable names
PROJECT_DIR="/src/$PROJECT_NAME"
USERNAME=$(whoami)

# Validate inputs explicitly
if [ -z "$PROJECT_NAME" ]; then
    echo "ERROR: PROJECT_NAME environment variable is not set" >&2
    exit 1
fi

# Use consistent error messages
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory $PROJECT_DIR does not exist" >&2
    exit 1
fi
```

## User Development Workflows

### Starting New Project

1. **Choose appropriate container**:
   ```bash
   # Python project
   docker run -it --rm \
     -v $(pwd):/src/my-python-app \
     -w /src/my-python-app \
     -e PROJECT_NAME=my-python-app \
     devastation/python:latest
   
   # .NET project
   docker run -it --rm \
     -v $(pwd):/src/my-dotnet-app \
     -w /src/my-dotnet-app \
     -e PROJECT_NAME=my-dotnet-app \
     devastation/dotnet:latest
   ```

2. **Initialize project inside container**:
   ```bash
   # Python project initialization
   poetry init
   poetry add requests pytest
   echo 'print("Hello, World!")' > main.py
   
   # .NET project initialization
   dotnet new console -n MyApp
   cd MyApp
   dotnet add package Newtonsoft.Json
   ```

### Development Session Management

#### Using tmux Effectively
**Window navigation**:
```bash
# Switch between windows
Ctrl+a 1  # Go to window 1 (shell)
Ctrl+a 2  # Go to window 2 (editor)
Ctrl+a 3  # Go to window 3 (test/language-specific)
Ctrl+a 4  # Go to window 4 (claude)

# Create additional windows
Ctrl+a c  # Create new window
Ctrl+a ,  # Rename current window
```

**Pane management**:
```bash
# Split current window
Ctrl+a |  # Split horizontally
Ctrl+a -  # Split vertically

# Navigate between panes
Ctrl+a h  # Move to left pane
Ctrl+a j  # Move to bottom pane
Ctrl+a k  # Move to top pane
Ctrl+a l  # Move to right pane
```

#### Neovim Development Workflow
**File navigation**:
```bash
# In Neovim
<Space>e   # Toggle file explorer
<Space>ff  # Find files with fuzzy search
<Space>fg  # Live grep through project
<Space>fb  # Switch between open buffers
```

**LSP features**:
```bash
# Code navigation
gd         # Go to definition
gr         # Find references
K          # Show hover information
<Space>rn  # Rename symbol
<Space>ca  # Code actions
```

**Debugging**:
```bash
# Debug workflow
<Space>db  # Toggle breakpoint
<Space>dc  # Start/continue debugging
<Space>ds  # Step over
<Space>di  # Step into
<Space>do  # Step out
```

### Configuration Customization

#### Personal Neovim Customization
```bash
# Create custom config directory
mkdir -p ~/.config/custom-nvim

# Override specific configurations
cp devastation/base/.config/nvim/lua/config/telescope.lua ~/.config/custom-nvim/

# Edit customizations
vim ~/.config/custom-nvim/telescope.lua

# Use custom config in container
docker run -it --rm \
  -v $(pwd):/src/my-project \
  -v ~/.config/custom-nvim:/home/dev/.config/nvim \
  -w /src/my-project \
  -e PROJECT_NAME=my-project \
  devastation/python:latest
```

#### Git Configuration Persistence
```bash
# Set up persistent git config
mkdir -p ~/.config/git
cat > ~/.config/git/config << EOF
[user]
  name = Your Name
  email = your.email@example.com
  
[core]
  editor = nvim
  
[alias]
  st = status
  co = checkout
  br = branch
  ci = commit
EOF

# Mount in all containers
-v ~/.config/git:/home/dev/.config/git
```

### Project-Specific Workflows

#### Multi-Language Projects
```bash
# Project with both Python and infrastructure
project/
├── api/           # Python API (use python container)
├── infrastructure/ # Terraform (use cluster container)
└── frontend/      # Node.js (use base container with Node)

# Work on different parts with appropriate containers
cd project/api
docker run -it --rm \
  -v $(pwd):/src/project-api \
  -w /src/project-api \
  -e PROJECT_NAME=project-api \
  devastation/python:latest

cd project/infrastructure  
docker run -it --rm \
  -v $(pwd):/src/project-infra \
  -w /src/project-infra \
  -e PROJECT_NAME=project-infra \
  devastation/cluster:latest
```

#### Development with External Services
```bash
# Development with database dependencies
docker run -it --rm \
  -v $(pwd):/src/my-app \
  -w /src/my-app \
  -e PROJECT_NAME=my-app \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db \
  --network my-dev-network \
  devastation/python:latest
```

### Troubleshooting Common Issues

#### Container Won't Start
1. **Check PROJECT_NAME is set**:
   ```bash
   echo $PROJECT_NAME  # Should output your project name
   ```

2. **Verify project directory exists**:
   ```bash
   ls -la /src/$PROJECT_NAME  # Should list project files
   ```

3. **Check volume mounts**:
   ```bash
   docker run --rm \
     -v $(pwd):/src/debug \
     -e PROJECT_NAME=debug \
     devastation/base:latest \
     ls -la /src/
   ```

#### Neovim Issues
1. **Plugin loading errors**:
   ```bash
   # Check plugin status
   nvim --headless '+Lazy check' +qa
   
   # Reinstall plugins
   nvim --headless '+Lazy! sync' +qa
   ```

2. **LSP not working**:
   ```bash
   # Check LSP server installation
   which python-lsp-server  # For Python
   which omnisharp         # For .NET
   
   # Check LSP status in Neovim
   :LspInfo
   ```

#### Permission Issues
```bash
# Fix file ownership if needed
sudo chown -R $USER:$USER $(pwd)

# Check USER_UID/USER_GID match
docker run --rm devastation/base:latest id
id  # Compare with host
```

### Performance Optimization

#### Container Build Caching
```bash
# Use BuildKit for better caching
export DOCKER_BUILDKIT=1

# Build with cache mount for package managers
docker buildx build \
  --cache-from devastation/base:latest \
  --cache-to type=inline \
  -t devastation/python:latest \
  ./python
```

#### Volume Mount Optimization
```bash
# Use bind mounts for active development
-v $(pwd):/src/my-project

# Use named volumes for cache directories
-v nvim-plugins:/home/dev/.local/share/nvim
-v npm-cache:/home/dev/.config/npm/cache
```

This comprehensive development workflow enables both contributors and users to effectively work with devastation containers while maintaining consistency and quality across the ecosystem.