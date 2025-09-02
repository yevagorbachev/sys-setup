mlint = {};

mlint.error = function(msg) vim.notify("mlint: " .. msg, vim.log.levels.ERROR, {}); end
-- mlint.log = function(msg) vim.notify("mlint: " .. msg, vim.log.levels.ERROR, {}); end
mlint.log = function(_) return; end;

mlint.path = vim.g.mlint_exe_path;
mlint.ns = vim.api.nvim_create_namespace("mlint");
mlint.levels_path = vim.fn.resolve(vim.fn.stdpath("data") .. 
    "/mlint_message_levels.json")

local decode_message_levels = function(text)
	local levels_map = {};

	-- local mlint_groups = {}
	-- for group, description in string.gmatch(text, "%s*(%u+)%s*%=+ ([^=]+) %=") do
	--     mlint_groups[group] = description;
	-- end
	--
	for errcode, sev, message in string.gmatch(text, 
		"%s*([%a%d]+)%s+(%d+)%s+([^\r\n]+)\n") do

		mlint.log(errcode .. " " .. sev .. " " .. message);

		sev = tonumber(sev);
		if sev >= 2 then
			levels_map[errcode] = "ERROR";
		elseif sev == 1 then
			levels_map[errcode] = "WARN";
		elseif sev == 0 then
			levels_map[errcode] = "INFO";
		else 
			levels_map[errcode] = "HINT";
			-- should be unreachable
		end
	end

    return levels_map;
end

local setup_levels = function()
	local levels_map = {};
	local levels_file = io.open(mlint.levels_path, "r");
	if levels_file ~= nil then
		local data = levels_file:read("*a");
		levels_map = vim.fn.json_decode(data);
	else
		local msglist = vim.fn.system({mlint.path, "-allmsg", mlint.path});
		levels_map = decode_message_levels(msglist);

		levels_file = io.open(mlint.levels_path, "w");
		levels_file:write(vim.fn.json_encode(levels_map));
	end

    levels_file:close();

	return levels_map;
end

local run_mlint = function(bufnr)
    local file_path = vim.api.nvim_buf_get_name(bufnr);
    local mlint_cmdlist = {mlint.path, file_path, "-id"};

    local mlint_callback = function(_, data, _) 
        mlint.log("Mlint responded\n" .. vim.fn.json_encode(data));
        -- vim.notify("Mlint completed:\n" .. vim.fn.json_encode(data), vim.log.levels.DEBUG, {});

        local qf_items = {};
        local diag_items = {};

        local pattern = "L (%d+) %(C (%d+)-?(%d*)%): (%u+)%: ([^\r\n]+)";
        for _, line in ipairs(data) do
            lnum, col, endcol, errcode, text = string.match(line, pattern);
            if lnum == nil then
                mlint.log("Did not match line against captures: " .. line);
			elseif lnum ~= nil then
                mlint.log("Matched line number: " .. lnum);

				lnum = tonumber(lnum);
				col = tonumber(col);
				endcol = tonumber(endcol) or col;

				local sev = mlint.levels_map[errcode] or "WARN";

                local qf_entry = {bufnr = bufnr, 
					lnum = lnum, col = col, end_col = endcol,
                    user_data = errcode, text = text, 
					type = string.sub(sev, 1, 1)};
                local diag_entry = {namespace = mlint.ns,
                    lnum = lnum-1, col = col-1, end_col = endcol-1,
                    code = errcode, message = text, 
					severity = vim.diagnostic.severity[sev]};

                table.insert(qf_items, qf_entry);
                table.insert(diag_items, diag_entry);
                -- vim.notify(vim.fn.json_encode(diag_entry), vim.log.levels.DEBUG, {});
            end
        end
        mlint.log("Diagnostic items:\n" .. vim.fn.json_encode(diag_items));

        vim.fn.setqflist({}, 'r', {items = qf_items});
        vim.diagnostic.reset(mlint.ns, bufnr);
        vim.diagnostic.set(mlint.ns, bufnr, diag_items);
    end

    local mlint_job = vim.fn.jobstart(mlint_cmdlist, {
        on_stderr = mlint_callback, 
        -- mlint writes to stderr on Windows, not stdout
        -- solution inspired by https://vi.stackexchange.com/questions/25025/neovim-jobstart-not-receiving-stdout-sometimes-if-async-i-think
        stderr_buffered = true, 
        stdin = "null"
    });

    if mlint_job == 0 then
		mlint.error("Mlint job not started: invalid arguments");
	elseif mlint_job == -1 then
		mlint.error("Mlint job not started: mlint is not exectuable");
	else
		vim.fn.jobwait({mlint_job}, 0);
    end
end

if mlint.path == nil then
	mlint.error("vim.g.mlint_exe_path not specified");
	return
end
if not vim.fn.executable(mlint.path) then
	mlint.error(mlint.path + " is not exectuable");
	return
end

mlint.levels_map = setup_levels();
vim.api.nvim_create_augroup("mlint", {
    clear = true,
});
vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    group = "mlint",
    pattern = "*.m",
    callback = function (args)
        run_mlint(args["buf"]);
    end, 
});
