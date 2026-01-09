local dap = require('dap')
-- dap.adapters.lldb = {
	-- type = 'executable',
	-- command = '${cfg.dap.package}/bin/lldb-dap',
	-- name = 'lldb'
-- }
dap.configurations.cpp = {
	{
		name = 'Lanuch',
		type = 'lldb',
		request = 'lanuch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},
	},
  {
    name = 'Attach to process',
    type = 'lldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    -- pid = function()
    --   local input = vim.fn.input('PID: ')
    --   local num = tonumber(input)
    --   if not num then
    --     error('Invaild PID: ' .. input)
    --   end
    --   return num
    -- end,
		cwd = '${workspaceFolder}',
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp


dap.adapters.bashdb = {
  type = "executable",
  command = "bash-debug-adapter",
  name = "bashdb",
}
dap.configurations.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = "Launch file",
    showDebugOutput = true,
    -- pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
    -- pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
    trace = true,
    file = "${file}",
    program = "${file}",
    cwd = '${workspaceFolder}',
    -- pathCat = "cat",
    -- pathBash = "/bin/bash",
    -- pathMkfifo = "mkfifo",
    -- pathPkill = "pkill",
    args = {},
    -- argsString = '',
    -- env = {},
    -- terminalKind = "integrated",
  }
}
