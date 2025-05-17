-- Python-specific LSP configuration

local lspconfig = require('lspconfig')

-- Get shared capabilities and on_attach from base config
local capabilities = _G.devastation.lsp.capabilities
local on_attach = _G.devastation.lsp.on_attach

-- Configure Python LSP (python-lsp-server)
lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 100
        }
      }
    }
  }
}