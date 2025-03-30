-- DAP (Debug Adapter Protocol) Configuration

local dap = require('dap')
local dapui = require('dapui')

-- Configure DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- Add listeners to automatically open and close the DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Enable virtual text
require("nvim-dap-virtual-text").setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = '<module',
  virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil
}

-- Define keymaps for debugging
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Set Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = "Continue" })
vim.keymap.set('n', '<leader>dC', dap.run_to_cursor, { desc = "Run to Cursor" })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = "Step Into" })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = "Step Over" })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = "Step Out" })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = "Toggle REPL" })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Run Last" })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle UI" })
vim.keymap.set('n', '<leader>dx', dap.terminate, { desc = "Terminate" })

-- Make DAP available globally for language-specific configurations
_G.devastation = _G.devastation or {}
_G.devastation.dap = dap

-- Note: language-specific debug adapters will be configured in their respective language containers
-- This file provides the base DAP setup