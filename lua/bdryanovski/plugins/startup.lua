return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		dashboard.section.header.val = {

			[[]],
			[[     ▄█ ███    █▄     ▄████████     ███         ]],
			[[    ███ ███    ███   ███    ███ ▀█████████▄     ]],
			[[    ███ ███    ███   ███    █▀     ▀███▀▀██     ]],
			[[    ███ ███    ███   ███            ███   ▀     ]],
			[[    ███ ███    ███ ▀███████████     ███         ]],
			[[    ███ ███    ███          ███     ███         ]],
			[[    ███ ███    ███    ▄█    ███     ███         ]],
			[[█▄ ▄███ ████████▀   ▄████████▀     ▄████▀       ]],
			[[▀▀▀▀▀▀                                          ]],
			[[ ▄█     █▄   ▄██████▄     ▄████████    ▄█   ▄█▄ ]],
			[[███     ███ ███    ███   ███    ███   ███ ▄███▀ ]],
			[[███     ███ ███    ███   ███    ███   ███▐██▀   ]],
			[[███     ███ ███    ███  ▄███▄▄▄▄██▀  ▄█████▀    ]],
			[[███     ███ ███    ███ ▀▀███▀▀▀▀▀   ▀▀█████▄    ]],
			[[███     ███ ███    ███ ▀███████████   ███▐██▄   ]],
			[[███ ▄█▄ ███ ███    ███   ███    ███   ███ ▀███▄ ]],
			[[ ▀███▀███▀   ▀██████▀    ███    ███   ███   ▀█▀ ]],
			[[                         ███    ███   ▀         ]],
			[[                    ... or some shit like that! ]],
		}

		dashboard.section.header.opts.position = "center"

		dashboard.opts.redraw_on_resize = true
		dashboard.opts.margin = 15

		alpha.setup(dashboard.opts)
	end,
}
