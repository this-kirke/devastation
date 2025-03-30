# Devastation Development Guidelines

## Build Commands
- Build container: `docker buildx build -t devastation/base:latest ./base`
- Run container: `docker run -it --rm devastation/base:latest`
- Custom user build: `docker buildx build --build-arg USERNAME=$(whoami) -t devastation/base:latest ./base`
- Neovim plugin install: `nvim --headless "+Lazy! sync" +qa`
- Treesitter update: `nvim --headless "+TSUpdateSync" +qa`

## Code Style
- **Indentation**: 2 spaces for Lua, 4 spaces for other languages
- **Naming**: camelCase for variables/functions, PascalCase for classes/types
- **Imports**: Group by external/internal, sort alphabetically
- **Error Handling**: Use pcall/xpcall pattern for Lua error handling
- **Line Length**: 80 characters maximum
- **Docker**: Use continuation backslashes for multiline RUN commands
- **Commenting**: Include purpose descriptions for functions and complex logic
- **Dockerfile**: Follow ARG/ENV/RUN organization pattern with section headers

## Formatting
- Format Lua: Use :Neoformat or builtin LSP formatting
- Organize Neovim files: configs in config/, separate modules in lua/
- Docker: Group related commands in single RUN statements to reduce layers

## Development Flow
- Container entry via entrypoint.sh loads tmux with pre-configured windows
- Edit Neovim configs in the ./config/nvim directory
- Follow modular organization for plugin configuration
- Use the project directory for development work