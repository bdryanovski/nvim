return {
	"nvim-pack/nvim-spectre",
	build = false,
	cmd = "Spectre",
	-- https://github.com/nvim-pack/nvim-spectre#customization
	opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word=true }) end, desc = "Search curren word (Spectre)"},
    },
}
