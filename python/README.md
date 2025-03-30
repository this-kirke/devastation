# Python Devastation

This devastation extends the base Devastation environment with Python-specific tools and configurations, providing a powerful Python development experience with Neovim.

## Features

- Python 3.11 with development packages
- Poetry for dependency management
- pytest for testing
- debugpy for debugging support
- python-lsp-server for code intelligence
- Neovim with Python-specific configuration:
  - Python LSP integration
  - Treesitter for Python syntax highlighting and code navigation
  - DAP configuration for Python debugging

## Usage

### Building the Devastation

From the project root directory:

```bash
# Build with default settings
docker buildx build -t devastation/python:latest ./python

# Or build with your current username
docker buildx build --build-arg USERNAME=$(whoami) -t devastation/python:latest ./python
```

### Running the Devastation

```bash
docker run -it --rm devastation/python:latest
```

## Neovim Configuration

### LSP Features

- Code completion
- Go to definition
- Find references
- Hover information
- Code actions
- Symbol renaming

### Debugging

The devastation is configured with debugging support through the Debug Adapter Protocol (DAP).

Key bindings:
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Start/Continue debugging
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dt` - Terminate debugging

## Package Management

Since this devastation runs in a Docker container, dependencies can be installed globally:

```bash
# Install dependencies directly
pip install package-name

# Or using poetry
poetry add package-name
```

For project-specific dependency tracking, Poetry is included and can be used to generate and maintain `pyproject.toml` and `poetry.lock` files.

## Customization

To further customize this devastation:

1. Add additional Python packages to the Dockerfile
2. Modify the LSP configuration in `config/nvim/lua/config/lsp.lua`
3. Adjust debugging settings in `config/nvim/lua/config/dap.lua`
4. Extend Treesitter functionality in `config/nvim/lua/config/treesitter.lua`