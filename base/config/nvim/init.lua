-- Base Devastation Neovim Configuration

-- Basic Editor Options
vim.g.mapleader = " "                     -- Set leader key to space
vim.g.maplocalleader = " "                -- Set local leader to space

-- Disable netrw in favor of neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- UI Options
vim.opt.number = true                     -- Show line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.cursorline = true                 -- Highlight current line
vim.opt.showmode = false                  -- Don't show mode (shown by lualine)
vim.opt.showtabline = 2                   -- Always show tabline
vim.opt.signcolumn = "yes"                -- Always show sign column
vim.opt.termguicolors = true              -- True color support
vim.opt.wrap = false                      -- Disable line wrapping

-- Behavior Options
vim.opt.clipboard = "unnamedplus"         -- Use system clipboard
vim.opt.mouse = "a"                       -- Enable mouse in all modes
vim.opt.undofile = true                   -- Persistent undo
vim.opt.updatetime = 300                  -- Faster updates
vim.opt.timeoutlen = 500                  -- Shorter timeout for mapped sequences
vim.opt.completeopt = "menu,menuone,noselect" -- Completion options

-- Search Options
vim.opt.ignorecase = true                 -- Ignore case in search
vim.opt.smartcase = true                  -- Override ignorecase when search has uppercase
vim.opt.hlsearch = true                   -- Highlight search results
vim.opt.incsearch = true                  -- Incremental search

-- Indentation Options
vim.opt.tabstop = 4                       -- Number of spaces for a tab
vim.opt.softtabstop = 4                   -- Number of spaces for a tab while editing
vim.opt.shiftwidth = 4                    -- Number of spaces for each indent level
vim.opt.expandtab = true                  -- Use spaces instead of tabs
vim.opt.smartindent = true                -- Auto indent new lines
vim.opt.breakindent = true                -- Wrapped lines preserve indentation

-- File Options
vim.opt.swapfile = false                  -- No swap file
vim.opt.backup = false                    -- No backup file
vim.opt.fileencoding = "utf-8"            -- Default file encoding

-- Basic Keymaps (more in lua/keymaps.lua)
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlights' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Navigate to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Navigate to bottom split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Navigate to top split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Navigate to right split' })

-- Load plugins
require("plugins")