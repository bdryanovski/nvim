return {
	"nvim-neotest/neotest",
	enabled = false,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		require("neotest").setup({
			benchmark = {
				enabled = true,
			},
			consumers = {},
			default_strategy = "integrated",
			diagnostic = {
				enabled = true,
				severity = 1,
			},
			discovery = {
				concurrent = 0,
				enabled = true,
			},
			floating = {
				border = "rounded",
				max_height = 0.6,
				max_width = 0.6,
				options = {},
			},
			adapters = {
				require("neotest-vitest")({
					-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
				}),
				require("neotest-jest")({
					jestConfigFile = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/packages/") then
							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
						end
						return vim.fn.getcwd() .. "/jest.config.ts"
					end,
					cwd = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/packages/") then
							return string.match(file, "(.-/[^/]+/)src")
						end
						return vim.fn.getcwd()
					end,
				}),
			},
			jump = {
				enabled = true,
			},
			log_level = 3,
			output = {
				enabled = true,
				open_on_run = "short",
			},
			quickfix = {
				enabled = true,
				open = false,
			},
			run = {
				enabled = true,
			},
			running = {
				concurrent = true,
			},
			state = {
				enabled = true,
			},
			status = {
				enabled = true,
				signs = true,
				virtual_text = true,
			},
			strategies = {
				integrated = {
					height = 40,
					width = 120,
				},
			},
			output_panel = {
				enabled = true,
				open = "botright split | resize 15",
			},
			summary = {
				animated = true,
				enabled = true,
				expand_errors = true,
				follow = true,
				mappings = {
					attach = "a",
					clear_marked = "M",
					clear_target = "T",
					debug = "d",
					debug_marked = "D",
					expand = { "<CR>", "<2-LeftMouse>" },
					expand_all = "e",
					help = "?",
					jumpto = "i",
					mark = "m",
					next_failed = "J",
					output = "o",
					prev_failed = "K",
					run = "r",
					run_marked = "R",
					short = "O",
					stop = "u",
					target = "t",
					watch = "w",
				},
				open = "botright vsplit | vertical resize 50",
			},
			config = function(_, opts)
				local neotest_ns = vim.api.nvim_create_namespace("neotest")
				vim.diagnostic.config({
					virtual_text = {
						format = function(diagnostic)
							-- Replace newline and tab characters with space for more compact diagnostics
							local message =
								diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
							return message
						end,
					},
				}, neotest_ns)

				require("neotest").setup(opts)
			end,
		})
	end,
	keys = {
		{
			";tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			";tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			";tT",
			function()
				require("neotest").run.run(vim.loop.cwd())
			end,
			desc = "Run All Test Files",
		},
		{
			";tl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run Last",
		},
		{
			";ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			";to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output",
		},
		{
			";tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			";tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop",
		},
	},
}
