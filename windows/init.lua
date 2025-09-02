-- Figure out what OS this is on 
SYSNAME = vim.loop.os_uname().sysname
local SYSNAME_WINDOWS = "Windows_NT"
local SYSNAME_LINUX = "Linux"

-- Command-mode command to edit the initfile (like UltiSnipsEdit)
vim.api.nvim_create_user_command("InitLuaEdit", function() 
	vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath("config") .. "/init.lua")) 
end, {nargs = 0});
vim.api.nvim_create_user_command("SwpDirOpen", function() 
	vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath("state") .. "/swap")) 
end, {nargs = 0});
vim.api.nvim_create_user_command("LspLogOpen", function ()
	vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath("state") .. "/lsp.log"))
end, {nargs = 0})

if SYSNAME_LINUX == SYSNAME then
    vim.opt.runtimepath:append("~/.vim");
    vim.cmd("source ~/.vimrc");
elseif SYSNAME_WINDOWS == SYSNAME then
    vim.opt.runtimepath:append("C:/Users/ygorbach/vimfiles");
    vim.cmd("source C:/Users/ygorbach/.vimrc");
    -- vim.opt.runtimepath:append("~/vimfiles");
end

vim.g.mlint_exe_path = "C:/Matlab/R2023b/bin/win64/mlint.exe";
