local lspconfig = require('lspconfig')

-- Configure C# LSP (OmniSharp)
lspconfig.omnisharp.setup {
  cmd = { "dotnet", "/usr/share/omnisharp-roslyn/OmniSharp.dll" },
  root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
  enable_roslyn_analyzers = false,
  organize_imports_on_format = true,
  enable_import_completion = true,
  filetypes = { "cs", "csx", "razor" },
  settings = {
    omnisharp = {
      useModernNet = true,
      monoPath = "",
      analyzeOpenDocumentsOnly = false,
      enableMsBuildLoadProjectsOnDemand = false,
      enableRoslynAnalyzers = false,
      enableImportCompletion = true,
      organizeImportsOnFormat = true
    }
  }
}

-- Add keybindings for LSP functionality
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover information' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })