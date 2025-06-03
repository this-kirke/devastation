# .NET Devastation

Complete .NET development environment with .NET 8 SDK, C# LSP support, debugging, and Azure integration. Built on the base devastation foundation.

## Purpose

Provides everything needed for modern .NET development including OmniSharp language server, debugging support, Azure Artifacts integration for private NuGet feeds, and comprehensive C# tooling.

## What's Included

### .NET Environment
- **.NET 8 SDK**: Latest stable .NET SDK with all development tools
- **Runtime Support**: Compatible with .NET 8, .NET 6 LTS, and .NET Framework
- **Azure Artifacts Provider**: For private NuGet feed authentication
- **MSBuild**: Complete build platform for .NET projects

### Development Tools
- **OmniSharp**: Language Server Protocol implementation for C#
- **netcoredbg**: Debug Adapter Protocol implementation for .NET
- **All base tools**: Neovim, tmux, Zsh, Git, Claude Code, etc.

### Neovim Integration
- **C# LSP**: Code completion, go-to-definition, error checking, refactoring
- **Debugging**: Full DAP integration with breakpoints and stepping
- **Syntax Highlighting**: C# Treesitter parser for advanced highlighting
- **Format on Save**: Automatic code formatting with EditorConfig support

## Building

```bash
# Build .NET container
make dotnet

# Build with custom username  
make USERNAME=$(whoami) dotnet

# Direct Docker build
docker buildx build -t devastation/dotnet:latest ./dotnet
```

## Usage

### Basic .NET Development
```bash
docker run -it --rm \
  -v $(pwd):/src/MyDotNetProject \
  -w /src/MyDotNetProject \
  -e PROJECT_NAME=MyDotNetProject \
  devastation/dotnet:latest
```

### With Azure DevOps NuGet Feeds
```bash
docker run -it --rm \
  -v $(pwd):/src/MyDotNetProject \
  -w /src/MyDotNetProject \
  -e PROJECT_NAME=MyDotNetProject \
  -e VSS_NUGET_EXTERNAL_FEED_ENDPOINTS='{"endpointCredentials":[{"endpoint":"https://pkgs.dev.azure.com/org/_packaging/feed/nuget/v3/index.json","password":"PAT","username":"PAT"}]}' \
  devastation/dotnet:latest
```

### With Configuration Persistence
```bash
docker run -it --rm \
  -v $(pwd):/src/MyDotNetProject \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.config/claude:/home/dev/.config/claude \
  -w /src/MyDotNetProject \
  -e PROJECT_NAME=MyDotNetProject \
  devastation/dotnet:latest
```

## tmux Windows

The container starts with four specialized windows:

1. **dotnet**: .NET CLI operations and project management
2. **editor**: Neovim with OmniSharp LSP active
3. **test**: Testing environment (dotnet test ready)
4. **claude**: Claude Code assistant

## Development Workflow

### Creating New Projects
```bash
# Console application
dotnet new console -n MyApp

# Web API
dotnet new webapi -n MyWebApi

# Class library
dotnet new classlib -n MyLibrary

# ASP.NET Core MVC
dotnet new mvc -n MyWebApp

# Solution with multiple projects
dotnet new sln -n MySolution
dotnet sln add MyApp/MyApp.csproj
dotnet sln add MyWebApi/MyWebApi.csproj
```

### Building and Running
```bash
# Restore dependencies
dotnet restore

# Build project
dotnet build

# Run application
dotnet run

# Run with specific configuration
dotnet run --configuration Release

# Watch for changes (hot reload)
dotnet watch run
```

### Package Management
```bash
# Add NuGet package
dotnet add package Newtonsoft.Json

# Add specific version
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0

# Remove package
dotnet remove package Newtonsoft.Json

# List installed packages
dotnet list package

# Update packages
dotnet list package --outdated
```

### Testing
```bash
# Create test project
dotnet new xunit -n MyApp.Tests

# Add reference to main project
dotnet add MyApp.Tests/MyApp.Tests.csproj reference MyApp/MyApp.csproj

# Run all tests
dotnet test

# Run with detailed output
dotnet test --verbosity normal

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test
dotnet test --filter "TestMethodName"
```

## Neovim Features

### LSP Capabilities
- **IntelliSense**: Context-aware code completion with type information
- **Go to Definition**: `gd` to navigate to type/member definitions
- **Find References**: `gr` to locate all symbol usages across solution
- **Hover Information**: `K` to show type info and documentation
- **Code Actions**: `Space + ca` for quick fixes and refactoring
- **Rename Symbol**: `Space + rn` to rename across entire codebase
- **Error Diagnostics**: Real-time syntax and semantic error detection

### Debugging
- **Set Breakpoint**: `Space + db`
- **Start Debug**: `Space + dc`
- **Step Over**: `Space + ds`
- **Step Into**: `Space + di`
- **Step Out**: `Space + do`
- **View Variables**: Debug UI shows local variables and call stack

### Code Quality
- **Format on Save**: Automatic code formatting
- **Organize Imports**: Remove unused, sort alphabetically
- **EditorConfig**: Respects project formatting rules

## Project Structure Examples

### Web API Project
```
MyWebApi/
├── Controllers/
│   ├── WeatherForecastController.cs
│   └── ValuesController.cs
├── Models/
│   └── WeatherForecast.cs
├── Services/
│   └── WeatherService.cs
├── Program.cs
├── appsettings.json
├── appsettings.Development.json
└── MyWebApi.csproj
```

### Console Application
```
MyConsoleApp/
├── Models/
│   └── DataModel.cs
├── Services/
│   └── BusinessService.cs
├── Program.cs
└── MyConsoleApp.csproj
```

### Solution with Tests
```
MySolution/
├── src/
│   ├── MyLibrary/
│   │   ├── Services/
│   │   └── MyLibrary.csproj
│   └── MyWebApi/
│       ├── Controllers/
│       └── MyWebApi.csproj
├── tests/
│   ├── MyLibrary.Tests/
│   │   └── MyLibrary.Tests.csproj
│   └── MyWebApi.Tests/
│       └── MyWebApi.Tests.csproj
└── MySolution.sln
```

## Customization

### Add .NET Tools
```dockerfile
FROM devastation/dotnet:latest

# Install global .NET tools
RUN dotnet tool install --global dotnet-ef
RUN dotnet tool install --global dotnet-outdated-tool

# Add additional NuGet sources
RUN dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
```

### Custom NuGet Configuration
```bash
# Mount NuGet config for custom feeds
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.nuget:/home/dev/.nuget \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/dotnet:latest
```

### Override OmniSharp Settings
Create custom OmniSharp config:
```json
{
  "FormattingOptions": {
    "EnableEditorConfigSupport": true,
    "OrganizeImports": true
  },
  "RoslynExtensionsOptions": {
    "EnableAnalyzersSupport": true,
    "EnableImportCompletion": true
  }
}
```

## Azure DevOps Integration

### Private NuGet Feeds
Set up authentication for private feeds:
```bash
export VSS_NUGET_EXTERNAL_FEED_ENDPOINTS='{"endpointCredentials":[{"endpoint":"https://pkgs.dev.azure.com/myorg/_packaging/myfeed/nuget/v3/index.json","password":"YOUR_PAT","username":"PAT"}]}'
```

### Package Sources
Add private package sources to your project:
```xml
<PackageReference Include="MyPrivatePackage" Version="1.0.0" />
```

## Common Commands

```bash
# Project management
dotnet new <template>           # Create new project from template
dotnet sln add <project>        # Add project to solution
dotnet add reference <project>  # Add project reference

# Development
dotnet restore                  # Restore NuGet packages
dotnet build                    # Build project
dotnet run                      # Run application
dotnet watch run               # Run with hot reload

# Testing
dotnet test                     # Run all tests
dotnet test --logger trx       # Generate test results file
dotnet test --collect:"XPlat Code Coverage"  # Run with coverage

# Publishing
dotnet publish -c Release      # Publish release build
dotnet publish --self-contained # Create self-contained deployment
```

## Requirements

- `PROJECT_NAME` environment variable must be set
- Project must be mounted to `/src/$PROJECT_NAME`
- .NET 8 compatible code (also supports .NET 6 LTS)

The container validates these requirements and provides clear error messages if not met.