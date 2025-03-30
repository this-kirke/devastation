-- Cluster-specific Treesitter configuration
-- Add cluster-related parsers to the ones from base configuration

require('nvim-treesitter.configs').setup({
  ensure_installed = { "terraform", "hcl", "yaml", "json", "bash" }
})