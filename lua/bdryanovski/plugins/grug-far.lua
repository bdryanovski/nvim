return {
	"MagicDuck/grug-far.nvim",
	config = function()
		-- Documentation:
		-- https://github.com/MagicDuck/grug-far.nvim/blob/main/doc/grug-far-opts.txt
		--
		require("grug-far").setup({
			windowCreationCommand = "split",

			-- Optional, default keymaps. For easy asccess for me
			keymaps = {
				replace = { n = "<localleader>r" },
				qflist = { n = "<localleader>q" },
				syncLocations = { n = "<localleader>s" },
				syncLine = { n = "<localleader>l" },
				close = { n = "<localleader>c" },
				historyOpen = { n = "<localleader>t" },
				historyAdd = { n = "<localleader>a" },
				refresh = { n = "<localleader>f" },
				openLocation = { n = "<localleader>o" },
				openNextLocation = { n = "<down>" },
				openPrevLocation = { n = "<up>" },
				gotoLocation = { n = "<enter>" },
				pickHistoryEntry = { n = "<enter>" },
				abort = { n = "<localleader>b" },
				help = { n = "g?" },
				toggleShowCommand = { n = "<localleader>w" },
				swapEngine = { n = "<localleader>e" },
				previewLocation = { n = "<localleader>i" },
				swapReplacementInterpreter = { n = "<localleader>x" },
				applyNext = { n = "<localleader>j" },
				applyPrev = { n = "<localleader>k" },
				syncNext = { n = "<localleader>n" },
				syncPrev = { n = "<localleader>p" },
				syncFile = { n = "<localleader>v" },
				nextInput = { n = "<tab>" },
				prevInput = { n = "<s-tab>" },
			},
		})

		vim.keymap.set("n", "<leader>fw", function()
			require("grug-far").open({
				prefills = {
					search = vim.fn.expand("<cword>"),
				},
			})
		end, { desc = "Find word under cursor" })

		vim.keymap.set("n", "<leader>fif", function()
			require("grug-far").open({
				prefills = {
					paths = vim.fn.expand("%"),
				},
			})
		end, { desc = "Find only in this file" })
	end,
}
