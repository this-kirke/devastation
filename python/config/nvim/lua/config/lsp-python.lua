-- Python-specific LSP configuration
-- This file will be loaded after the base configuration

local lspconfig = require('lspconfig')

-- Get shared capabilities and on_attach from base config
local capabilities = _G.devastation.lsp.capabilities
local on_attach = _G.devastation.lsp.on_attach

-- Configure Python LSP
lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          maxLineLength = 100
        },
        jedi_completion = {
          enabled = true,
          include_params = true
        },
        jedi_definition = {
          enabled = true
        },
        jedi_hover = {
          enabled = true
        },
        jedi_references = {
          enabled = true
        },
        jedi_signature_help = {
          enabled = true
        },
        jedi_symbols = {
          enabled = true,
          all_scopes = true
        }
      }
    }
  }
}