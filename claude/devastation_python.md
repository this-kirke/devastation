# Python Devastation Container

## Purpose

Extends the base devastation with Python development tools, LSP integration, debugging support, and Python-specific Neovim configuration.

## Python Environment

### Python Version
- **Python 3.11**: Latest stable version with development headers
- **pip**: Package installer with latest version
- **Poetry**: Modern dependency management and packaging tool

### Development Tools
- **pytest**: Testing framework for unit and integration tests
- **debugpy**: Debug Adapter Protocol implementation for Python
- **python-lsp-server**: Language Server Protocol implementation

### Global Packages
```bash
pip install poetry pytest debugpy python-lsp-server
```

## Neovim Extensions

### Language Server Configuration
**File**: `config/lsp-python.lua`

```lua
-- Python LSP configuration
local lspconfig = require('lspconfig')

lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },  -- Disable style warnings
        mccabe = { enabled = false },       -- Disable complexity warnings
        pyflakes = { enabled = true },      -- Enable syntax checking
        pylint = { enabled = false },       # Use external linting
      }
    }
  }
}
```

### Debug Configuration
**File**: `config/dap-python.lua`

```lua
-- Python Debug Adapter Protocol setup
local dap = require('dap')

dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return '/usr/bin/python'
    end,
  },
}
```

### Treesitter Configuration
**File**: `config/treesitter-python.lua`

```lua
-- Python-specific Treesitter configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = { "python" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  fold = {
    enable = true
  }
}
```

## Dockerfile Implementation

### Extension Pattern
```dockerfile
FROM devastation/base:latest

# Install Python and development tools
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    python3.11-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Python development tools
RUN pip install --no-cache-dir poetry pytest debugpy python-lsp-server

# Copy Python-specific Neovim configurations
COPY ./.config /home/$USERNAME/.config/

# Apply Python-specific Neovim configurations
RUN echo '\n-- Python-specific configurations\nrequire("config.lsp-python")\nrequire("config.dap-python")\nrequire("config.treesitter-python")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua

# Install Treesitter parser for Python
RUN nvim --headless "+TSInstall python" +qa

ENTRYPOINT ["/usr/local/bin/python-entrypoint.sh"]
```

## tmux Window Layout

### Window Configuration
1. **python**: Python REPL and script execution
2. **editor**: Neovim with Python LSP active
3. **test**: Testing environment (pytest, coverage)
4. **claude**: Claude Code assistant

### Entrypoint Implementation
**File**: `python-entrypoint.sh`

```bash
#!/bin/bash

# Validate environment (inherited from base pattern)
if [ -z "$PROJECT_NAME" ]; then
    echo "ERROR: PROJECT_NAME environment variable is not set"
    exit 1
fi

PROJECT_DIR="/src/$PROJECT_NAME"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory $PROJECT_DIR does not exist"
    exit 1
fi

# Start tmux session with Python-specific windows
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "python"
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t dev:2 "nvim" C-m
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "test"
tmux send-keys -t dev:3 "echo 'Ready for pytest'" C-m
tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "claude"
tmux send-keys -t dev:4 "claude" C-m

tmux select-window -t dev:1
exec tmux attach-session -t dev
```

## Development Workflow

### Project Setup
```bash
# Initialize new Python project
poetry init
poetry add requests pytest  # Add dependencies
poetry install              # Create virtual environment

# Run in development mode
poetry shell                # Activate virtual environment
python main.py             # Run application
pytest                     # Run tests
```

### Debugging in Neovim
1. Set breakpoints: `<leader>db`
2. Start debugging: `<leader>dc`
3. Step through code: `<leader>ds` (step over), `<leader>di` (step into)
4. View variables in DAP UI panels

### LSP Features Available
- **Code Completion**: Intelligent suggestions based on context
- **Go to Definition**: Jump to function/class definitions
- **Find References**: Locate all usages of symbols
- **Hover Information**: Type hints and documentation
- **Code Actions**: Refactoring and quick fixes
- **Symbol Renaming**: Rename variables/functions across project

## Package Management Strategy

### Poetry Workflow
```bash
# Add production dependency
poetry add requests

# Add development dependency  
poetry add pytest --group dev

# Install all dependencies
poetry install

# Run commands in virtual environment
poetry run python main.py
poetry run pytest
```

### Container Package Strategy
Since the container is ephemeral, install packages globally or use Poetry to manage project-specific dependencies. The container provides the base Python environment, while Poetry manages project dependencies.

## Testing Integration

### pytest Configuration
Default `pytest.ini` or `pyproject.toml` configuration:

```toml
[tool.pytest.ini_options]
minversion = "6.0"
addopts = "-ra -q --tb=short"
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
```

### Test Discovery
- Tests in `tests/` directory
- Files matching `test_*.py` or `*_test.py`
- Functions starting with `test_`
- Classes starting with `Test`

## Container Usage Patterns

### Basic Development
```bash
docker run -it --rm \
  -v $(pwd):/src/MyPythonProject \
  -w /src/MyPythonProject \
  -e PROJECT_NAME=MyPythonProject \
  devastation/python:latest
```

### With Persistent Configuration
```bash
docker run -it --rm \
  -v $(pwd):/src/MyPythonProject \
  -v ~/.config/claude:/home/dev/.config/claude \
  -v ~/.config/git:/home/dev/.config/git \
  -w /src/MyPythonProject \
  -e PROJECT_NAME=MyPythonProject \
  devastation/python:latest
```

## Customization Points

### Additional Python Packages
Extend Dockerfile to add more Python tools:
```dockerfile
RUN pip install --no-cache-dir black isort mypy flake8
```

### LSP Server Alternatives
Replace `python-lsp-server` with `pyright`:
```dockerfile
RUN npm install -g pyright
```

### Testing Framework Alternatives
Add support for other testing tools:
```dockerfile
RUN pip install --no-cache-dir tox coverage nose2
```