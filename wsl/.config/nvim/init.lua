-- Figure out what OS this is on 
local system_lookup = {Windows_NT = "windows", Linux = "linux"}
SYSNAME = system_lookup[vim.loop.os_uname().sysname];
-- turn returned values into either "windows" or "linux" for convenience

-- currently untested
-- Install packer if it isn't already
-- Hopefully platform-independent with vim.fn.system, but we'll see
local packdir = vim.fn.resolve(vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim")
if not vim.loop.fs_stat(packdir) then
	print("Installing packer")
	vim.fn.system {
		"git", "clone",
		"--depth", "1",
		"https://github.com/wbthomason/packer.nvim",
		packdir
	}
end

vim.cmd("packadd packer.nvim")

-- configs
local cf_surround = function()
	require("nvim-surround").setup({});
end

local cf_autopairs = function()
	local rule = require("nvim-autopairs.rule");
	local aupairs = require("nvim-autopairs");
	local texs = {"tex", "latex"};

	aupairs.setup {
		check_ts = true,
	};

	aupairs.add_rules {
		rule("\\(", "\\)", texs),
		rule("\\left(", "\\right)", texs),
		rule("\\left[", "\\right]", texs),
		rule("\\left{", "\\right}", texs),
		rule("`", "'", texs),
		rule("``", "''", texs),
		rule("$", "$", {"matlab", "markdown"}),
	};
end

local cf_comment = function()
	require("Comment").setup({});
end

local cf_treesitter = function()
	local tsc = require("nvim-treesitter.configs")

	tsc.setup {
		sync_install = false,
		auto_install = false,
		ignore_install = {},
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymap = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<M-space>',
			},
		},
		textobjects = { -- None of these seem to work...
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymap = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
		}
	}

end

local cf_luasnip = function()
	local snipdir = vim.fn.resolve(vim.fn.stdpath("config") .. "/LuaSnip")
	require("luasnip.loaders.from_lua").load({paths = snipdir})
end

local cf_lspconfig = function()
    require("mason").setup();

    if SYSNAME == "linux" then
        require("mason-lspconfig").setup({
            ensure_installed = {"clangd", "texlab", "lua_ls", "zls"};
            automatic_enable = false,
        });


		vim.lsp.config("zls", {
			zig_exe_path = vim.fn.exepath("zig"),
			zig_lib_path = "/usr/lib/zig"
		})

        vim.lsp.enable("lua-language-server");
        vim.lsp.enable("clangd");
        vim.lsp.enable("texlab");
        vim.lsp.enable("zls");
    end

    if SYSNAME == "windows" then
        require("mason-lspconfig").setup({
            ensure_installed = {"matlab_ls"},
            automatic_enable = false,
        });


        local matlab_ls_path = vim.fn.exepath("matlab-language-server.cmd");

        vim.lsp.config("matlab_ls", {
			cmd = {
                "cmd.exe", "/C", matlab_ls_path,
                "--stdio", 
                "--matlabInstallPath", "C:/Progra~1/MATLAB/R2024b";
            },
			filetypes = {'matlab'},
            single_file_support = true,
            root_dir = function(bufnr, on_dir)
                local matcher = function(name, path)
                    return (name:match("%.prj$") ~= nil) or (name == ".git");
                end

                on_dir(vim.fs.root(bufnr, matcher));
            end,
            settings = {
                MATLAB = {
                    indexWorkspace = true,
                    installPath = "C:/Progra~1/MATLAB/R2024b",
                    matlabConnectionTiming = "onStart",
                    telemetry = true,
                }
            }
        });
        vim.lsp.enable("matlab_ls");
    end
end

local cf_cmp = function()
	cmp = require("cmp");
	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			["<C-p>"] = cmp.mapping.scroll_docs(-4),
			["<C-n>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body);
			end
		},
		sources = cmp.config.sources({
			{name = "nvim_lsp"}, 
			{name = "luasnip"},
		})
	})
end


local rtps = {linux = "~/.vim", windows = "~/vimfiles"};
vim.opt.runtimepath:append(rtps[SYSNAME]);
vim.cmd("source ~/.vimrc");

-- Command-mode command to edit the initfile (like UltiSnipsEdit)
-- Helper
local open_stdfile = function(stp, file)
    return function() vim.cmd.edit(vim.fn.resolve(vim.fn.stdpath(stp) .. file)); end
end
vim.api.nvim_create_user_command("InitLuaEdit", open_stdfile("config", "/init.lua"), {nargs = 0});
vim.api.nvim_create_user_command("SwpDirOpen", open_stdfile("state", "/swap"), {nargs = 0});
vim.api.nvim_create_user_command("LuaSnipReload", cf_luasnip, {nargs = 0});

require("packer").startup( function(use)
	-- Packer
	use "wbthomason/packer.nvim"

	-- Basics: Autopairs, Surround, Comment
	use {
		"kylechui/nvim-surround",
		tag = "*",
		config = cf_surround
	}

	use {
		"windwp/nvim-autopairs",
		config = cf_autopairs
	}
	use {
		"numToStr/comment.nvim",
		config = cf_comment
	}

	-- Navigation: Telescope & Harpoon
	use {
		"nvim-telescope/telescope.nvim",
		tag = "*",
		requires = {"nvim-lua/plenary.nvim"},
		config = cf_telescope
	}

	use {
		"theprimeagen/harpoon",
		branch = "harpoon2",
		requires = {"nvim-lua/plenary.nvim"},
		config = cf_harpoon
	}

	-- Advanced language support
	use {
		"nvim-treesitter/nvim-treesitter",
		config = cf_treesitter
	}

	use {
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter"
	}

	use {
		"nvim-treesitter/playground",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
		config = cf_tsp
	}

	use {
		"L3MON4D3/LuaSnip",
		config = cf_luasnip,
	}

	use {
		"neovim/nvim-lspconfig",
        requires = {"mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim"},
		config = cf_lspconfig,
	}

	use {
		"hrsh7th/nvim-cmp",
		after = {"LuaSnip", "mason.nvim", "nvim-treesitter"},
		requires = {
			{"saadparwaiz1/cmp_luasnip"},
			{"hrsh7th/nvim-cmp"},
			{"hrsh7th/cmp-buffer"},
			{"hrsh7th/cmp-path"},
			{"hrsh7th/cmp-nvim-lsp"},
		},
		config = cf_cmp
	}

	use {
		"folke/neodev.nvim"
	}

    use {
        "theprimeagen/vim-be-good"
    }
end);
