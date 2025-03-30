-- Python-specific DAP configuration

local dap = _G.devastation.dap

-- Configure Python debugger
dap.adapters.python = {
  type = 'executable',
  command = 'python3',
  args = {'-m', 'debugpy.adapter'}
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = "${file}",
    pythonPath = function()
      -- Detect if we're in a virtual environment
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      -- Default python path
      return 'python3'
    end,
    console = 'integratedTerminal'
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Launch with arguments',
    program = "${file}",
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
    pythonPath = function()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      return 'python3'
    end,
    console = 'integratedTerminal'
  },
  {
    type = 'python',
    request = 'attach',
    name = 'Attach remote',
    connect = function()
      local host = vim.fn.input('Host [127.0.0.1]: ')
      if host == '' then
        host = '127.0.0.1'
      end
      local port = tonumber(vim.fn.input('Port [5678]: '))
      if port == nil or port == 0 then
        port = 5678
      end
      return { host = host, port = port }
    end,
    pathMappings = {
      {
        localRoot = "${workspaceFolder}",
        remoteRoot = "."
      }
    }
  }
}