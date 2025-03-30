-- Cluster-specific LSP configuration

local lspconfig = require('lspconfig')

-- Get shared capabilities and on_attach from base config
local capabilities = _G.devastation.lsp.capabilities
local on_attach = _G.devastation.lsp.on_attach

-- Configure YAML LSP for Kubernetes
lspconfig.yamlls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml",
      },
      validate = true,
      completion = true,
      hover = true
    }
  }
}

-- Configure Terraform LSP
lspconfig.terraformls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}

-- Configure Bash LSP for scripts
lspconfig.bashls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}