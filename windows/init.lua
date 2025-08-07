-- Figure out what OS this is on 
SYSNAME = vim.loop.os_uname().sysname
local SYSNAME_WINDOWS = "Windows_NT"
local SYSNAME_LINUX = "Linux"

local INITFILE = vim.fn.resolve(vim.fn.stdpath("config") .. "/init.lua")
local SNIPDIR = vim.fn.resolve(vim.fn.stdpath("config") .. "/LuaSnip")

-- Command-mode command to edit the initfile (like UltiSnipsEdit)
vim.api.nvim_create_user_command("InitLuaEdit", function() 
	vim.cmd.edit(INITFILE) 
end, {nargs = 0});
vim.api.nvim_create_user_command("SwpDirOpen", function() 
	vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath("state") .. "/swap")) 
end, {nargs = 0});
vim.api.nvim_create_user_command("LspLogOpen", function ()
	vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath("state") .. "/lsp.log"))
end, {nargs = 0})

if SYSNAME_LINUX == SYSNAME then
    vim.opt.runtimepath:append("~/.vim");
end

if SYSNAME_WINDOWS == SYSNAME then
    -- vim.opt.runtimepath:append("C:/Users/ygorbach/vimfiles");
    vim.opt.runtimepath:append("~/vimfiles");
end
vim.cmd("source ~/.vimrc");

MLINT_MESSAGE_PATH = vim.fn.resolve(vim.fn.stdpath("config") .. "/mlint_messages.json");

local generate_mlint_map = function()
    local bufnr = 0;
    local file_path = vim.api.nvim_buf_get_name(bufnr);
    local mlint_path = "C:/Matlab/R2023b/bin/win64/mlint.exe";
    local mlint_cmdlist = {mlint_path, "-allmsg", file_path, "-id"};

    local data = vim.fn.system(mlint_cmdlist);

    -- local groups_path = vim.fn.resolve(vim.fn.stdpath("config") .. "/mlint_groups.json");
    -- local mlint_groups = {}
    -- for group, description in string.gmatch(data, "%s*(%u+)%s*%=+ ([^=]+) %=") do
    --     vim.notify(group .. " " .. description, vim.log.levels.DEBUG, {});
    --     mlint_groups[group] = description;
    -- end

    local mlint_messages = {};
    for errcode, sev, message in string.gmatch(data, "%s*([%a%d]+)%s+(%d+)%s+([^\r\n]+)\n") do
        -- vim.notify(errcode .. " " .. sev .. " " .. message, vim.log.levels.DEBUG, {});
        sev = tonumber(sev);
        if sev >= 2 then
            mlint_messages[errcode] = "ERROR";
        elseif sev == 1 then
            mlint_messages[errcode] = "WARN";
        elseif sev == 0 then
            mlint_messages[errcode] = "INFO";
        else 
            mlint_messages[errcode] = "HINT";
            -- should be unreachable
        end
    end
    -- vim.notify(vim.fn.json_encode(mlint_messages), vim.log.levels.DEBUG, {});

    local mlint_message_file = io.open(MLINT_MESSAGE_PATH, "w");
    mlint_message_file:write(vim.fn.json_encode(mlint_messages));
    mlint_message_file:close();
end

vim.api.nvim_create_user_command("MakeMlintMap", generate_mlint_map, {nargs = 0});

local mlint_message_file = io.open(MLINT_MESSAGE_PATH, "r");
if mlint_message_file ~= nil then
    MLINT_MESSAGE_MAP = vim.fn.json_decode(mlint_message_file:read("*a"))
    mlint_message_file:close();
else
    MLINT_MESSAGE_MAP = {};
    vim.notify("Mlint message map not generated", vim.log.levels.WARN, {});
end


local mlint_to_diags = function(bufnr)
    local mlint = vim.api.nvim_create_namespace("mlint");
    local file_path = vim.api.nvim_buf_get_name(bufnr);
    local mlint_path = "C:/Matlab/R2023b/bin/win64/mlint.exe";
    local mlint_cmdlist = {mlint_path, file_path, "-id"};

    local mlint_callback = function(_, data, _) 
        -- vim.notify("Mlint completed:\n" .. vim.fn.json_encode(data), vim.log.levels.DEBUG, {});

        local qf_items = {};
        local diag_items = {};

        pattern = "L (%d+) %(C (%d+)-?(%d*)%): (%u+)%: ([^\r\n]+)";
        for _, line in ipairs(data) do
            lnum, col, endcol, errcode, text = string.match(line, pattern);
            -- if lnum == nil then
            --     vim.notify("Did not match line against captures: " .. line, vim.log.levels.DEBUG, {});
            if lnum ~= nil then
                -- vim.notify("Matched line number: " .. lnum, vim.log.levels.DEBUG, {});
                local qf_entry = {bufnr = bufnr, lnum = lnum, col = col, end_col = endcol,
                    user_data = errcode, text = text, type = 'W'};
                local diag_entry = {source = "mlint",
                    lnum = tonumber(lnum) - 1, col = tonumber(col) - 1, 
                    code = errcode, message = text, 
                    severity = vim.diagnostic.severity.WARN};

                endcol = tonumber(endcol);
                if endcol ~= nil then 
                    diag_entry["end_col"] = endcol - 1; 
                end

                local sev = MLINT_MESSAGE_MAP[errcode];

                if sev ~= nil then
                    diag_entry["severity"] = vim.diagnostic.severity[sev];
                end

                table.insert(qf_items, qf_entry);
                table.insert(diag_items, diag_entry);
                -- vim.notify(vim.fn.json_encode(diag_entry), vim.log.levels.DEBUG, {});
            end
        end

        -- vim.notify("Diagnostic items:\n" .. vim.fn.json_encode(diag_items), vim.log.levels.DEBUG, {});
        vim.fn.setqflist({}, 'r', {items = qf_items});
        vim.diagnostic.reset(mlint, bufnr);
        vim.diagnostic.set(mlint, bufnr, diag_items);
        -- vim.notify("QF populated", vim.log.levels.DEBUG, {});
    end

    -- data = vim.fn.system(mlint_cmdlist);
    -- mlint_callback(0, data, 0);


    local mlint_job = vim.fn.jobstart(mlint_cmdlist, {
        on_stderr = mlint_callback, 
        -- mlint writes to stderr on Windows, not stdout
        -- solution inspired by https://vi.stackexchange.com/questions/25025/neovim-jobstart-not-receiving-stdout-sometimes-if-async-i-think
        stderr_buffered = true, 
        stdin = "null"
    });

    if mlint_job == 0 then
        vim.notify("Invalid job arguments", vim.log.levels.ERROR, {});
        return
    end
    if mlint_job == -1 then
        vim.notify("Mlint is not executable", vim.log.levels.ERROR, {});
        return
    end
    -- vim.notify("Job started on channel " .. mlint_job, vim.log.levels.DEBUG, {});

    vim.fn.jobwait({mlint_job}, 0);
end

vim.api.nvim_create_augroup("mlint", {clear = false});
vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    group = "mlint",
    pattern = "*.m",
    callback = function (args)
        mlint_to_diags(args["buf"]);
    end, 
});

-- running mlint with -allmsg identifies 
-- TODO create a function that runs -allmsg and generates a JSON defining the
-- type of each error ID
