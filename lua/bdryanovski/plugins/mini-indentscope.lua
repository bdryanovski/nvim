-- return { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }
--
return {
	"echasnovski/mini.indentscope",
	version = false,
	config = function()
		require("mini.indentscope").setup({
			-- Draw options
			draw = {
				-- Delay (in ms) between event and start of drawing scope indicator
				delay = 100,

				-- Animation rule for scope's first drawing. A function which, given
				-- next and total step numbers, returns wait time (in ms). See
				-- |MiniIndentscope.gen_animation| for builtin options. To disable
				-- animation, use `require('mini.indentscope').gen_animation.none()`.
				-- animation = --<function: implements constant 20ms between steps>,

				-- Whether to auto draw scope: return `true` to draw, `false` otherwise.
				-- Default draws only fully computed scope (see `options.n_lines`).
				predicate = function(scope)
					return not scope.body.is_incomplete
				end,

				-- Symbol priority. Increase to display on top of more symbols.
				priority = 2,
			},

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Textobjects
				object_scope = "ii",
				object_scope_with_border = "ai",

				-- Motions (jump to respective border line; if not present - body line)
				goto_top = "[i",
				goto_bottom = "]i",
			},

			-- Options which control scope computation
			options = {
				-- Type of scope's border: which line(s) with smaller indent to
				-- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
				border = "both",

				-- Whether to use cursor column when computing reference indent.
				-- Useful to see incremental scopes with horizontal cursor movements.
				indent_at_cursor = true,

				-- Maximum number of lines above or below within which scope is computed
				n_lines = 10000,

				-- Whether to first check input line to be a border of adjacent scope.
				-- Use it if you want to place cursor on function header to get scope of
				-- its body.
				try_as_border = false,
			},

			-- Which character to use for drawing scope indicator
			symbol = "╎",
		})
	end,
}
