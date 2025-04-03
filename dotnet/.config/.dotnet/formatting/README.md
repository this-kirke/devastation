# .NET Formatting Configuration

These configuration files for .NET code formatting and StyleCop analysis are included in the `devastation/dotnet` container at `/home/dev/.config/dotnet/formatting/`.

## Configuration Files

- `.editorconfig`: Controls code formatting, spacing, and indentation across editors
- `stylecop.json`: StyleCop Analyzer configuration for code style rules
- `stylecop.ruleset`: Custom ruleset for StyleCop Analyzers with specific rule overrides

## Usage in Projects

To use these configuration files in your .NET projects:

1. Install the required package:

```
dotnet add package StyleCop.Analyzers
```

2. Add the following to your .csproj file:

```xml
<PropertyGroup>
  <CodeAnalysisRuleSet>/home/dev/.config/dotnet/formatting/stylecop.ruleset</CodeAnalysisRuleSet>
</PropertyGroup>

<ItemGroup>
  <AdditionalFiles Include="/home/dev/.config/dotnet/formatting/stylecop.json" Link="stylecop.json" />
</ItemGroup>
```

These files are automatically included in the `devastation/dotnet` container at `/home/dev/.config/dotnet/formatting/`.

## Key Formatting Rules

- Tabs for indentation (size 4)
- LF line endings
- File-scoped namespaces
- No braces before open brace
- Parameters on new line when more than 2 parameters
- Spaces inside method parameter parentheses
- Spaces between square brackets
- Private field names prefixed with underscore