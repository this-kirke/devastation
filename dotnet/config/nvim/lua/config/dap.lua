local dap = require('dap')

-- Configure .NET debugger
dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      local cwd = vim.fn.getcwd()
      local function find_dll()
        local files = vim.fn.glob(cwd .. "/bin/Debug/**/*.dll", true, true)
        -- Filter out unwanted DLLs (typically test and dependency DLLs)
        for _, file in ipairs(files) do
          if file:match("%.dll$") and not file:match("%.Tests%.dll$") and not file:match("%.resources%.dll$") then
            -- Get the corresponding project name
            local project_name = file:match("/([^/]+)%.dll$")
            if project_name then
              local csproj_files = vim.fn.glob(cwd .. "/**/" .. project_name .. ".csproj", true, true)
              if #csproj_files > 0 then
                return file
              end
            end
          end
        end
        return nil
      end

      local dll_path = find_dll()
      if dll_path then
        return dll_path
      else
        return vim.fn.input('Path to dll: ', cwd .. '/bin/Debug/', 'file')
      end
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    type = "coreclr",
    name = "attach - netcoredbg",
    request = "attach",
    processId = function()
      local handle = io.popen("ps -A | grep -m 1 -i dotnet | awk '{print $1}'")
      local result = handle:read("*a")
      handle:close()
      result = result:gsub("%s+", "")
      if result == "" then
        return vim.fn.input('Process ID: ')
      end
      return result
    end,
  }
}

-- .NET-specific keybindings for debugging
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Start/Continue debugging' })
vim.keymap.set('n', '<leader>ds', function() require('dap').step_over() end, { desc = 'Step over' })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step into' })
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Terminate debugging' })