local dap = require('dap')
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode',
	name = 'lldb'
}
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
    args = {},
  },
}
-- dap.configurations.sh = {
--   {
--     type = 'bashdb',
--     request = 'launch',
--     name = "Launch file",
--     showDebugOutput = true,
--     -- pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
--     -- pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
--     trace = true,
--     file = "${file}",
--     program = "${file}",
--     cwd = '${workspaceFolder}',
--     pathCat = "cat",
--     pathBash = "/bin/bash",
--     pathMkfifo = "mkfifo",
--     pathPkill = "pkill",
--     args = {},
--     argsString = '',
--     env = {},
--     terminalKind = "integrated",
--   }
-- }
