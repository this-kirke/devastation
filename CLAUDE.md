# Devastation Development Guidelines

## Build Commands
- Build all containers: `make all`
- Build specific container: `make base`, `make python`, `make cluster`
- Clean up images: `make clean`
- Custom user build: `make USERNAME=yourname base`
- Run container: `docker run -it --rm devastation/base:latest`
- Neovim plugin install: `nvim --headless "+Lazy! sync" +qa`
- Treesitter update: `nvim --headless "+TSUpdateSync" +qa`
- Show help: `make help`
- Claude Code: `claude` (available in all containers)

## Git Workflow
- Commit style: Use descriptive messages with a summary line and detailed body
- Branch naming: Use descriptive names prefixed with feature/, bugfix/, or docs/
- Before committing: Run `git status` and `git diff` to review changes

## Testing
- Test each container by running: `docker run -it --rm devastation/<container>:latest zsh -c "nvim --version"`
- Check plugins: `docker run -it --rm devastation/<container>:latest zsh -c "nvim --headless '+Lazy check' +qa"`
- Verify Claude Code: `docker run -it --rm devastation/<container>:latest zsh -c "claude --version"`

## Code Style
- **Indentation**: 2 spaces for Lua, 4 spaces for other languages
- **Line Length**: 80 characters maximum
- **Naming**: camelCase for variables/functions, PascalCase for classes/types
- **Imports**: Group external, then internal; sort alphabetically
- **Docker**: Use continuation backslashes for multiline RUN commands
- **Dockerfile**: Follow ARG/ENV/RUN organization with section headers
- **Dockerfile Efficiency**: Execute commands directly in RUN statements, avoid temp scripts
- **Error Handling**: Use pcall/xpcall pattern for Lua error handling
- **Plugin Format**: Follow the plugin block format in plugins.lua with config functions
- **Commit Style**: Conventional commits (feat/fix/docs/chore/refactor)

## Repository Organization
- Base image extends Ubuntu 22.04 with dev tools
- Language-specific images extend base with specialized tools
- XDG-style configuration in .config directory:
  - Zsh config in .config/zsh/ with ZDOTDIR environment variable
  - Tmux config in .config/tmux/
  - Neovim config in .config/nvim/
- Neovim config naming pattern:
  - Base configs: `config/lsp-base.lua`, `config/treesitter-base.lua`, `config/dap-base.lua`
  - Language configs: `config/lsp-python.lua`, `config/treesitter-cluster.lua`, etc.
  - Base plugins.lua loads the `-base` configs directly
  - Language Dockerfiles append imports for language-specific modules to plugins.lua
- Simple config copying: `COPY ./.config /home/$USERNAME/.config/`
- Container entry via entrypoint.sh loads tmux with pre-configured windows