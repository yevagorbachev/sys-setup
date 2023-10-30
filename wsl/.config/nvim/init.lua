vim.cmd("source ~/.vimrc")
vim.cmd("packadd packer.nvim")

-- Helpers
resolve = vim.fn.resolve
user_cmd = vim.api.nvim_create_user_command
vim_edit = vim.cmd.edit
stdpath = vim.fn.stdpath
keymap = vim.keymap.set
load_snips = function()
	require("luasnip.loaders.from_lua").load({paths = SNIPDIR})
end

-- Figure out what OS this is on 
-- SYSNAME = vim.loop.os_uname().sysname
-- local WINDOWS = "Windows_NT"
-- local LINUX = "Linux"

-- Useful globals
INITFILE = resolve(stdpath("config") .. "/init.lua")
SNIPDIR = resolve(stdpath("config") .. "/LuaSnip")
PACKDIR = resolve(stdpath("data") .. "/site/pack/packer/start/packer.nvim")

-- currently untested
-- Install packer if it isn't already
-- Hopefully platform-independent with vim.fn.system, but we'll see
if not vim.loop.fs_stat(PACKDIR) then
	print("Installing packer")
	vim.fn.system {
		"git", "clone",
		"--depth", "1",
		"https://github.com/wbthomason/packer.nvim",
		PACKDIR
	}
end

-- Command-mode command to edit the initfile (like UltiSnipsEdit)
user_cmd("InitLuaEdit", function() vim_edit(INITFILE) end, {nargs = 0})
user_cmd("LuaSnipReload", load_snips, {nargs = 0})

-- configs
local cf_surround = function()
	require("nvim-surround").setup {}
end

local cf_autopairs = function()
	require("nvim-autopairs").setup {}
end

local cf_comment = function()
	require("Comment").setup {toggler = {line = "<C-;>"}}
end

local cf_telescope = function()
	local builtin = require("telescope.builtin")

	keymap("n", "<leader>sf", function() builtin.find_files({follow = true}) end)
end

local cf_harpoon = function()
	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")

	keymap("n", "<leader>a", mark.add_file)
	keymap("n", "<leader>h", ui.toggle_quick_menu)
	keymap("n", "<C-d>", ui.nav_next)
	keymap("n", "<C-f>", ui.nav_prev)
end

local cf_treesitter = function()
	local tsc = require("nvim-treesitter.configs")

	tsc.setup {
		ensure_installed = {
			"c", "cpp", "matlab", "python", -- proper languages
			"make", "cmake", "bash", "lua", "luadoc", -- scripting
			"html", "latex", "bibtex", "markdown_inline", -- text
			"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", -- git
		},
		sync_install = true,
		auto_install = true,
		ignore_install = {},
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
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
				keymaps = {
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

local cf_lspzero = function()
	-- setup and configure lsp-zero
	local lsp = require("lsp-zero").preset {}

	lsp.on_attach(function(_, bufnr)
		local opts = {buffer = bufnr, remap = false}

		keymap("n", "gd", vim.lsp.buf.definition, opts)
		keymap("n", "K", vim.lsp.buf.signature_help, opts)
		keymap("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)
		keymap("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		keymap("n", "<leader>vrr", vim.lsp.buf.references, opts)
		keymap("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		keymap("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	end)

	-- setup completion
	local cmp = require("cmp")
	local cmp_action = require("lsp-zero").cmp_action()

	-- load luasnips
	load_snips()

	require("luasnip").config.set_config {
		enable_autosnippets = true,
		update_events = "TextChanged,TextChangedI"
	}

	user_cmd("LuaSnipEdit", function() vim_edit(SNIPDIR) end, {nargs = 0})

	cmp.setup {
		snippet = {
			expand = function(args)
				ls.lsp_expand(args.body)
			end
		},
		mapping = {
			-- `Enter` key to confirm completion

			['<Tab>'] = cmp.mapping(function(fallback)
				local ls = require("luasnip")
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
					else
						cmp.confirm()
					end
				elseif ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					fallback()
				end
			end),
			-- ['<Tab>'] = cmp.mapping.confirm({select = true}),
			['<CR>'] = cmp.mapping.select_next_item(),
			['<C-CR>'] = cmp.mapping.select_prev_item(),
			-- Ctrl+Space to close menu if unwanted
			['<C-Space>'] = cmp.mapping.close(),
			-- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
			-- ['<C-b>'] = cmp_action.luasnip_jump_backward(),
			-- ['<Tab>'] = cmp_action.tab_complete(),
			-- ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
			-- Navigate between snippet placeholder
			-- ['<Tab>'] = cmp_action.luasnip_supertab(),
			['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		},
		preselect = "item",
		completion = {
			completeopt = "menu,menuone,noinsert"
		},
		sources = {
			{name = "luasnip", keyword_length = 2, priority = 3},
			{name = "nvim_lsp", keyword_lenghth = 3, priority = 2, max_item_count = 2},
			-- {name = "buffer", keyword_length = 3, priority = 1, max_item_count = 2}
		},
		view = {
			entries = 'custom'
		},
		enabled = function()
			-- disable completion in comments
			local context = require 'cmp.config.context'
			-- keep command mode completion enabled when cursor is in a comment
			if vim.api.nvim_get_mode().mode == 'c' then
				return true
			else
				return not context.in_treesitter_capture("comment")
					and not context.in_syntax_group("Comment")
			end
		end,
	}

	local lspc = require("lspconfig")
	lsp.ensure_installed({
		"lua_ls", "clangd", "texlab", "matlab_ls"
	})

	local capabilities = require("cmp_nvim_lsp").default_capabilities();
	lspc.lua_ls.setup {capabilities = capabilities, lsp.nvim_lua_ls()}
	lspc.clangd.setup {capabilities = capabilities}
	lspc.texlab.setup {capabilities = capabilities}

	lspc.matlab_ls.setup {
		capabilities = capabilities,
		single_file_support = true,
		settings = {
			matlab = {
				indexWorkspace = false,
				installPath = "C:\\Program Files\\MATLAB\\R2022a",
				matlabConnectionTiming = 'onStart',
				telemetry = true,
			},
		},
	}
	lsp.setup()

end

local cf_tsp = function()
	keymap("n", "<leader>tsn", function() vim.cmd("TSNodeUnderCursor") end)
end
-- run packer, loading configs
local packer = require("packer")
packer.startup( function(use)
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
		requires = {"nvim-lua/plenary.nvim"},
		config = cf_harpoon
	}

	-- Advanced language support
	use {
		"nvim-treesitter/nvim-treesitter",
		{run = ":TSUpdate"}, -- execute every time the package is updated
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
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{"neovim/nvim-lspconfig"},
			{"williamboman/mason.nvim"},
			{"williamboman/mason-lspconfig.nvim"},

			-- Autocompletion
			{"L3MON4D3/LuaSnip"},
			{"saadparwaiz1/cmp_luasnip"},
			{"hrsh7th/nvim-cmp"},
			{"hrsh7th/cmp-buffer"},
			{"hrsh7th/cmp-nvim-lsp"},
		},
		config = cf_lspzero
	}
	use {
		"hrsh7th/cmp-nvim-lsp",
	}
end)

