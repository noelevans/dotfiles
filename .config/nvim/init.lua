--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true

-- Disable mouse
vim.opt.mouse = ""

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
-- vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
-- vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 1

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Don't highlight search by default
vim.opt.hlsearch = false
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- Use `opts = {}` to force a plugin to be loaded.

	"tpope/vim-commentary",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"tpope/vim-jdaddy",
	"mhinz/vim-grepper",
	"navarasu/onedark.nvim",

	-- LSP config
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-buffer",
		},
		branch = "v3.x",
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			-- to learn how to use mason.nvim
			-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			require("mason").setup({})
			require("mason-lspconfig").setup({
				handlers = {
					function(pyright)
						require("lspconfig")[pyright].setup({})
					end,
					function(lua_ls)
						require("lspconfig")[lua_ls].setup({})
					end,
				},
			})
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
				},
			})
		end,
	},

	{
		"ibhagwan/fzf-lua",
		-- dependencies = { "sharkdp/bat" },
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({
				fzf_opts = {
					["--layout"] = "reverse-list",
				},
				defaults = {
					git_icons = false,
					file_icons = false,
				},
				winopts = {
					height = 0.6,
					width = 1,
					row = 1,
					preview = {
						default = "bat",
						layout = "horizontal",
						scrollbar = "float",
					},
				},
				manpages = { previewer = "man_native" },
				helptags = { previewer = "help_native" },
				lsp = { code_actions = { previewer = "codeaction_native" } },
				tags = { previewer = "bat" },
				btags = { previewer = "bat" },
				files = { fzf_opts = { ["--ansi"] = false } },
			})
			fzf.setup_fzfvim_cmds()
		end,
	},

	{
		"noelevans/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = false,
				},
				cursorword = {
					enable = true,
					min_length = 1,
					hl = {
						fg = "#c0caf5",
						bg = "#565f89",
						underline = false,
					},
					insert_highlighting = false,
				},
			})
		end,
	},

	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
	--    require('gitsigns').setup({ ... })
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
	--
	-- This is often very useful to both group configuration, as well as handle
	-- lazy loading plugins that don't need to be loaded immediately at startup.
	--
	-- For example, in the following configuration, we use:
	--  event = 'VimEnter'
	--
	-- which loads which-key before all the UI elements are loaded. Events can be
	-- normal autocommands events (`:help autocmd-events`).
	--
	-- Then, because we use the `config` key, the configuration only runs
	-- after the plugin has been loaded:
	--  config = function() ... end

	{ -- Autoformat
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "query", "bash", "c", "html", "lua", "markdown", "vim", "vimdoc", "python" },
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["as"] = "@scope",
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							-- ["@class.outer"] = "<c-v>", -- blockwise
						},
						include_surrounding_whitespace = false,
					},
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_b = { "branch", "diff" },
					lualine_c = {
						{
							"filename",
							path = 3,
						},
						function()
							return require("nvim-treesitter").statusline({
								transform_fn = function(line)
									return line:gsub("%s*[%[%(%{]*%s*$", "")
										:gsub("class ", "")
										:gsub("^def ", "")
										:gsub("%(.*%)", "")
										:gsub(":", "")
								end,
								-- indicator_size = 100,
								type_patterns = { "class", "function", "method" },
								-- separator = " -> ",
							})
						end,
					},
					lualine_x = { "diagnostics" },
				},
			})
		end,
	},
}, {
	ui = {},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

local gs = package.loaded.gitsigns
vim.keymap.set("n", "<leader>sh", gs.stage_hunk)
vim.keymap.set("n", "<leader>uh", gs.reset_hunk)
vim.keymap.set("v", "<leader>hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("v", "<leader>hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("n", "<leader>sH", gs.stage_buffer)
vim.keymap.set("n", "<leader>uH", gs.undo_stage_hunk)
vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
vim.keymap.set("n", "<leader>ph", gs.preview_hunk)
vim.keymap.set("n", "<leader>nh", gs.next_hunk)
vim.keymap.set("n", "<leader>ph", gs.prev_hunk)
vim.keymap.set("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end)
vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame)
-- vim.keymap.set("n", "<leader>dh", gs.diffthis)
vim.keymap.set("n", "<leader>dH", function()
	gs.diffthis("~")
end)
vim.keymap.set("n", "<leader>td", gs.toggle_deleted)

vim.keymap.set("n", "<leader>gg", ":GrepperRg <C-R><C-W>")
vim.keymap.set("n", "<leader>dh", function()
	vim.diagnostic.hide()
end)
vim.keymap.set("n", "<leader>ds", function()
	vim.diagnostic.show()
end)
vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "<C-l>", "<C-i>")

vim.cmd([[ iabbrev pdb breakpoint() ]])
vim.cmd([[ iabbrev tpdb from nose.tools import set_trace; set_trace() ]])

vim.keymap.set("ca", "AG", "GrepperAg")
vim.keymap.set("ca", "RG", "GrepperRg")

vim.keymap.set("n", "<leader>ll", function()
	company = require("company")
	local prefix = company.base .. "/-/blob/"
	local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
	local filename = vim.fn.bufname()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	print(prefix .. branch .. "/" .. filename .. "#L" .. line)
end)

vim.diagnostic.config({
	update_in_insert = false,
	underline = false,
	virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
	signs = { severity = { min = vim.diagnostic.severity.ERROR } },
})
-- vim.lsp.handlers["textDocument/publishDiagnostics"] =
-- 	vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
-- 		signs = { severity = { min = vim.diagnostic.severity.ERROR } },
-- 		virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
-- 		underline = { severity = { min = vim.diagnostic.severity.ERROR } },
-- 	})
