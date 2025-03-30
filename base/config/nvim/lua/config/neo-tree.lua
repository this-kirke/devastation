-- Neo-tree Configuration

require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = " ",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "✚",
        deleted   = "✖",
        modified  = "",
        renamed   = "",
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
        conflict  = "",
      },
    },
  },
  window = {
    position = "left",
    width = 30,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  },
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".git",
        "node_modules",
      },
      never_show = {
        ".DS_Store",
      },
    },
  },
})

-- Keymaps for Neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle File Explorer" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus File Explorer" })