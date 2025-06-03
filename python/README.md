# Python Devastation

Complete Python development environment with Python 3.11, LSP support, debugging, and testing tools. Built on the base devastation foundation.

## Purpose

Provides everything needed for Python development including language server integration, debugging support, dependency management with Poetry, and testing with pytest.

## What's Included

### Python Environment
- **Python 3.11**: Latest stable Python with development headers
- **pip**: Package installer with latest version  
- **Poetry**: Modern dependency management and packaging
- **pytest**: Testing framework for unit and integration tests
- **debugpy**: Debug Adapter Protocol implementation for Python

### Development Tools
- **python-lsp-server**: Language Server Protocol for code intelligence
- **All base tools**: Neovim, tmux, Zsh, Git, Claude Code, etc.

### Neovim Integration
- **Python LSP**: Code completion, go-to-definition, error checking
- **Debugging**: Full DAP integration with breakpoints and stepping
- **Syntax Highlighting**: Python Treesitter parser for advanced highlighting
- **Testing Integration**: Easy pytest execution from editor

## Building

```bash
# Build Python container
make python

# Build with custom username
make USERNAME=$(whoami) python

# Direct Docker build
docker buildx build -t devastation/python:latest ./python
```

## Usage

### Basic Python Development
```bash
docker run -it --rm \
  -v $(pwd):/src/MyPythonProject \
  -w /src/MyPythonProject \
  -e PROJECT_NAME=MyPythonProject \
  devastation/python:latest
```

### With Configuration Persistence
```bash
docker run -it --rm \
  -v $(pwd):/src/MyPythonProject \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.config/claude:/home/dev/.config/claude \
  -w /src/MyPythonProject \
  -e PROJECT_NAME=MyPythonProject \
  devastation/python:latest
```

## tmux Windows

The container starts with four specialized windows:

1. **python**: Python REPL and script execution
2. **editor**: Neovim with Python LSP active
3. **test**: Testing environment (pytest ready)
4. **claude**: Claude Code assistant

## Development Workflow

### Starting a New Project
```bash
# Inside the container
poetry init                    # Initialize pyproject.toml
poetry add requests           # Add dependencies
poetry add pytest --group dev # Add dev dependencies
poetry install               # Create virtual environment
```

### Running Code
```bash
# Execute Python scripts
python main.py

# Use Poetry environment
poetry run python main.py
poetry run pytest
```

### Testing
```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src

# Run specific test file
pytest tests/test_example.py

# Run with verbose output
pytest -v
```

## Neovim Features

### LSP Capabilities
- **Code Completion**: Intelligent suggestions based on context
- **Go to Definition**: `gd` to jump to function/class definitions
- **Find References**: `gr` to find all symbol usages
- **Hover Info**: `K` to show documentation and type hints
- **Code Actions**: `Space + ca` for quick fixes and refactoring
- **Rename Symbol**: `Space + rn` to rename across the project

### Debugging
- **Set Breakpoint**: `Space + db`
- **Start Debug**: `Space + dc`
- **Step Over**: `Space + ds`
- **Step Into**: `Space + di`
- **Step Out**: `Space + do`
- **View Variables**: Debug UI shows local and global variables

### File Navigation
- **File Explorer**: `Space + e`
- **Find Files**: `Space + ff`
- **Search in Files**: `Space + fg`
- **Find Buffers**: `Space + fb`

## Customization

### Add Python Tools
```dockerfile
FROM devastation/python:latest

# Add additional Python tools
RUN pip install --no-cache-dir \
    black \
    isort \
    mypy \
    flake8 \
    bandit
```

### Custom Poetry Configuration
```bash
# Mount Poetry config for custom settings
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.config/pypoetry:/home/dev/.config/pypoetry \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/python:latest
```

### Override Python LSP Settings
Create custom LSP config and mount it:
```lua
-- custom-lsp.lua
local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = true },
        mccabe = { enabled = true },
        pyflakes = { enabled = true },
      }
    }
  }
}
```

## Project Structure Examples

### Web API Project
```
my-api/
├── src/
│   ├── __init__.py
│   ├── main.py
│   └── models/
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── pyproject.toml
└── README.md
```

### Data Science Project
```
data-project/
├── notebooks/
│   └── analysis.ipynb
├── src/
│   ├── data/
│   ├── models/
│   └── utils/
├── tests/
├── data/
│   ├── raw/
│   └── processed/
└── pyproject.toml
```

### CLI Tool Project
```
cli-tool/
├── src/
│   ├── cli.py
│   ├── commands/
│   └── utils/
├── tests/
├── pyproject.toml
└── README.md
```

## Common Commands

```bash
# Package management
poetry add package-name        # Add dependency
poetry add pytest --group dev  # Add dev dependency
poetry remove package-name     # Remove dependency
poetry show                    # List installed packages
poetry update                  # Update all dependencies

# Virtual environment
poetry shell                   # Activate virtual environment
poetry env info               # Show environment info
poetry env list               # List available environments

# Testing and quality
pytest                        # Run tests
pytest --cov=src             # Run with coverage
black .                      # Format code
isort .                      # Sort imports
mypy src/                    # Type checking
```

## Requirements

- `PROJECT_NAME` environment variable must be set
- Project must be mounted to `/src/$PROJECT_NAME`
- Python 3.11 compatible code

The container validates these requirements and provides clear error messages if not met.