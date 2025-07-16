return {
	"folke/snacks.nvim",
	opts = {
		bigfile = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		picker = { enabled = false },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		dashboard = {
			width = 60,
			preset = {
				header = [[
			     ▄█ ███    █▄     ▄████████     ███         
			    ███ ███    ███   ███    ███ ▀█████████▄     
			    ███ ███    ███   ███    █▀     ▀███▀▀██     
			    ███ ███    ███   ███            ███   ▀     
			    ███ ███    ███ ▀███████████     ███         
			    ███ ███    ███          ███     ███         
			    ███ ███    ███    ▄█    ███     ███         
			█▄ ▄███ ████████▀   ▄████████▀     ▄████▀       
			▀▀▀▀▀▀                                          
			 ▄█     █▄   ▄██████▄     ▄████████    ▄█   ▄█▄ 
			███     ███ ███    ███   ███    ███   ███ ▄███▀ 
			███     ███ ███    ███   ███    ███   ███▐██▀   
			███     ███ ███    ███  ▄███▄▄▄▄██▀  ▄█████▀    
			███     ███ ███    ███ ▀▀███▀▀▀▀▀   ▀▀█████▄    
			███     ███ ███    ███ ▀███████████   ███▐██▄   
			███ ▄█▄ ███ ███    ███   ███    ███   ███ ▀███▄ 
			 ▀███▀███▀   ▀██████▀    ███    ███   ███   ▀█▀ 
			                         ███    ███   ▀         
			                    ... or some shit like that! 
        ]],
				pick = nil,
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			formats = {
				footer = { "%s", align = "center" },
				header = { "%s", align = "center" },
				file = function(item, ctx)
					local fname = vim.fn.fnamemodify(item.file, ":~")
					fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
					if #fname > ctx.width then
						local dir = vim.fn.fnamemodify(fname, ":h")
						local file = vim.fn.fnamemodify(fname, ":t")
						if dir and file then
							file = file:sub(-(ctx.width - #dir - 2))
							fname = dir .. "/…" .. file
						end
					end
					local dir, file = fname:match("^(.*)/(.+)$")
					return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
				end,
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{
					pane = 2,
					icon = " ",
					desc = "Browse Repo",
					padding = 1,
					key = "b",
					action = function()
						Snacks.gitbrowse()
					end,
				},
				function()
					local in_git = Snacks.git.get_root() ~= nil
					local cmds = {
						{
							title = "Open Issues",
							cmd = "gh issue list -L 3",
							key = "i",
							action = function()
								vim.fn.jobstart("gh issue list --web", { detach = true })
							end,
							icon = " ",
							height = 7,
						},
						{
							icon = " ",
							title = "Open PRs",
							cmd = "gh pr list -L 3",
							key = "P",
							action = function()
								vim.fn.jobstart("gh pr list --web", { detach = true })
							end,
							height = 7,
						},
					}

					return vim.tbl_map(function(cmd)
						return vim.tbl_extend("force", {
							pane = 2,
							section = "terminal",
							enabled = in_git,
							padding = 1,
							ttl = 5 * 60,
							indent = 3,
						}, cmd)
					end, cmds)
				end,
				{ section = "startup" },
			},
		},
		---@class snacks.dim.Config
		dim = {
			---@type snacks.scope.Config
			scope = {
				min_size = 5,
				max_size = 20,
				siblings = true,
			},
			-- animate scopes. Enabled by default for Neovim >= 0.10
			-- Works on older versions but has to trigger redraws during animation.
			---@type snacks.animate.Config|{enabled?: boolean}
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				easing = "outQuad",
				duration = {
					step = 20, -- ms per step
					total = 300, -- maximum duration
				},
			},
			-- what buffers to dim
			filter = function(buf)
				return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
			end,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
