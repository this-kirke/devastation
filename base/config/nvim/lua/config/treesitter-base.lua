-- Treesitter Configuration

require("nvim-treesitter.configs").setup({
  -- Base languages - language-specific containers will add more
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc", 
    "query",
    "json",
    "yaml",
    "markdown",
    "dockerfile",
    "bash"
  },
  
  -- Install parsers synchronously (only the ones in ensure_installed)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    enable = true,

    -- Disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    additional_vim_regex_highlighting = false,
  },

  -- Indentation based on treesitter for the = operator
  indent = {
    enable = true,
  },

  -- Incremental selection based on syntax tree
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<S-CR>",
      node_decremental = "<BS>",
    },
  },
  
  -- Enable text objects for treesitter
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ar"] = "@parameter.outer",
        ["ir"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- Add jumps to jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})