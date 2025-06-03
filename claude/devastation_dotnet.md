# .NET Devastation Container

## Purpose

Extends the base devastation with .NET development tools, C# LSP integration, debugging support, and .NET-specific Neovim configuration for building modern .NET applications.

## .NET Environment

### .NET SDK
- **.NET 8 SDK**: Latest stable version with all development tools
- **Runtime Support**: Supports .NET 8, .NET 6 LTS, and .NET Framework compatibility
- **Azure Artifacts Provider**: Configured for private NuGet feeds

### Development Tools
- **dotnet CLI**: Complete command-line interface for .NET development
- **NuGet**: Package manager with Azure DevOps integration
- **MSBuild**: Build platform for .NET projects

### Global Tools Installation
```bash
# Azure Artifacts Credential Provider for private feeds
apt-get install -y azure-artifacts-credprovider

# Set up dotnet global tools path
export PATH="$PATH:/home/$USERNAME/.dotnet/tools"
```

## Neovim Extensions

### Language Server Configuration
**File**: `config/lsp-dotnet.lua`

```lua
-- C# LSP configuration using OmniSharp
local lspconfig = require('lspconfig')

lspconfig.omnisharp.setup {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      LoadProjectsOnDemand = false,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
    },
  },
  on_attach = function(client, bufnr)
    -- Enable format on save
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
```

### Debug Configuration
**File**: `config/dap-dotnet.lua`

```lua
-- .NET Debug Adapter Protocol setup
local dap = require('dap')

dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/local/bin/netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
```

### Treesitter Configuration
**File**: `config/treesitter-dotnet.lua`

```lua
-- C# Treesitter configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c_sharp" },
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

# Install .NET 8 SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

# Install Azure Artifacts Credential Provider
RUN apt-get update && apt-get install -y azure-artifacts-credprovider && \
    rm -rf /var/lib/apt/lists/*

# Install OmniSharp language server
RUN dotnet tool install --global omnisharp

# Install debugging tools
RUN wget https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz && \
    tar -xzf netcoredbg-linux-amd64.tar.gz -C /usr/local/bin && \
    rm netcoredbg-linux-amd64.tar.gz

# Copy .NET-specific Neovim configurations  
COPY ./.config /home/$USERNAME/.config/

# Apply .NET-specific Neovim configurations
RUN echo '\n-- .NET-specific configurations\nrequire("config.lsp-dotnet")\nrequire("config.dap-dotnet")\nrequire("config.treesitter-dotnet")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua

# Install Treesitter parser for C#
RUN nvim --headless "+TSInstall c_sharp" +qa

ENTRYPOINT ["/usr/local/bin/dotnet-entrypoint.sh"]
```

## tmux Window Layout

### Window Configuration
1. **dotnet**: .NET CLI operations and project management
2. **editor**: Neovim with OmniSharp LSP active
3. **test**: Testing environment (dotnet test, coverage)
4. **claude**: Claude Code assistant

### Entrypoint Implementation
**File**: `dotnet-entrypoint.sh`

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

# Start tmux session with .NET-specific windows
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "dotnet"
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t dev:2 "nvim" C-m
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "test"
tmux send-keys -t dev:3 "echo 'Ready for dotnet test'" C-m
tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "claude"
tmux send-keys -t dev:4 "claude" C-m

tmux select-window -t dev:1
exec tmux attach-session -t dev
```

## Development Workflow

### Project Creation
```bash
# Create new console application
dotnet new console -n MyApp
cd MyApp

# Create new web API
dotnet new webapi -n MyWebApi
cd MyWebApi

# Create new class library
dotnet new classlib -n MyLibrary
cd MyLibrary

# Create solution and add projects
dotnet new sln -n MySolution
dotnet sln add MyApp/MyApp.csproj
dotnet sln add MyWebApi/MyWebApi.csproj
```

### Development Commands
```bash
# Restore dependencies
dotnet restore

# Build project
dotnet build

# Run application
dotnet run

# Run with specific configuration
dotnet run --configuration Release

# Watch for changes and rebuild
dotnet watch run
```

### Testing Workflow
```bash
# Create test project
dotnet new xunit -n MyApp.Tests

# Add reference to main project
dotnet add MyApp.Tests/MyApp.Tests.csproj reference MyApp/MyApp.csproj

# Run tests
dotnet test

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test
dotnet test --filter "TestMethodName"
```

## Package Management

### NuGet Package Operations
```bash
# Add package reference
dotnet add package Newtonsoft.Json

# Add specific version
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0

# Remove package
dotnet remove package Newtonsoft.Json

# List packages
dotnet list package

# Update packages
dotnet list package --outdated
dotnet add package PackageName
```

### Azure DevOps Integration
The container includes Azure Artifacts Credential Provider for accessing private NuGet feeds:

```bash
# Configure feed authentication (done via environment variables)
export VSS_NUGET_EXTERNAL_FEED_ENDPOINTS='{"endpointCredentials":[{"endpoint":"https://pkgs.dev.azure.com/org/_packaging/feed/nuget/v3/index.json","password":"PAT","username":"PAT"}]}'
```

## Debugging in Neovim

### DAP Integration
1. **Set Breakpoints**: `<leader>db` in Neovim
2. **Start Debugging**: `<leader>dc`
3. **Step Over**: `<leader>ds`
4. **Step Into**: `<leader>di`
5. **Step Out**: `<leader>do`
6. **Continue**: `<leader>dc`
7. **Terminate**: `<leader>dt`

### Debug Configuration
- Automatically detects built DLL files
- Supports both console and web applications
- Integration with OmniSharp for symbol information

## LSP Features

### Code Intelligence
- **IntelliSense**: Context-aware code completion
- **Go to Definition**: Navigate to type/member definitions
- **Find All References**: Locate usage across solution
- **Rename Symbol**: Refactor names across entire codebase
- **Code Actions**: Quick fixes and refactoring suggestions
- **Hover Information**: Type information and documentation
- **Error Diagnostics**: Real-time syntax and semantic errors

### Formatting and Organization
- **Auto-format on Save**: Consistent code style
- **Organize Imports**: Remove unused, sort alphabetically
- **EditorConfig Support**: Respects project formatting rules

## Container Usage Patterns

### Basic Development
```bash
docker run -it --rm \
  -v $(pwd):/src/MyDotNetProject \
  -w /src/MyDotNetProject \
  -e PROJECT_NAME=MyDotNetProject \
  devastation/dotnet:latest
```

### With Azure DevOps Integration
```bash
docker run -it --rm \
  -v $(pwd):/src/MyDotNetProject \
  -v ~/.config/claude:/home/dev/.config/claude \
  -v ~/.config/git:/home/dev/.config/git \
  -w /src/MyDotNetProject \
  -e PROJECT_NAME=MyDotNetProject \
  -e VSS_NUGET_EXTERNAL_FEED_ENDPOINTS='...' \
  devastation/dotnet:latest
```

## Performance Considerations

### Build Performance
- **Incremental Builds**: dotnet build only rebuilds changed projects
- **Parallel Builds**: Multi-core compilation enabled by default
- **Package Caching**: NuGet packages cached in user profile

### Memory Usage
- **Release Mode**: Use `--configuration Release` for optimized builds
- **Self-Contained**: `--self-contained` for deployment packages
- **Trimming**: `--p:PublishTrimmed=true` for smaller binaries

## Common Project Types

### Web API Project Structure
```
MyWebApi/
├── Controllers/        # API controllers
├── Models/            # Data models
├── Services/          # Business logic
├── Program.cs         # Application entry point
├── appsettings.json   # Configuration
└── MyWebApi.csproj    # Project file
```

### Console Application Structure
```
MyConsoleApp/
├── Program.cs         # Entry point
├── Models/           # Data models
├── Services/         # Business logic
└── MyConsoleApp.csproj # Project file
```

### Test Project Structure
```
MyApp.Tests/
├── Controllers/       # Controller tests
├── Services/         # Service tests
├── Models/          # Model tests
├── TestData/        # Test fixtures
└── MyApp.Tests.csproj # Test project file
```