-- Python-specific Treesitter configuration
-- Add Python parser to the ones from base configuration

require('nvim-treesitter.configs').setup({
  ensure_installed = { "python" }
})