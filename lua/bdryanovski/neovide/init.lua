-- Neovide-specific configuration.
--
-- This file is only active when running inside Neovide (`vim.g.neovide` is set)
-- and tweaks rendering, animations and scaling for the GUI.
if vim.g.neovide then
	local g = vim.g

	-- Rendering and contrast
	g.neovide_text_gamma = 0.0
	g.neovide_text_contrast = 0.5

	-- Padding around the Neovide window content (in pixels).
	g.neovide_padding_top = 0
	g.neovide_padding_bottom = 0
	g.neovide_padding_right = 0
	g.neovide_padding_left = 0

	-- Scroll behaviour
	g.neovide_scroll_animation_length = 0.2
	g.neovide_scroll_animation_far_lines = 1
	g.neovide_hide_mouse_when_typing = false
	g.neovide_refresh_rate = 60
	g.neovide_refresh_rate_idle = 5
	-- g.neovide_remember_window_size = true
	g.neovide_profiler = false
	-- g.neovide_cursor_animation_length = 0.08

	-- Cursor visuals
	g.neovide_cursor_trail_size = 0.8
	g.neovide_cursor_antialiasing = true
	g.neovide_cursor_vfx_mode = "ripple"
	g.neovide_fullscreen = false

	-- GUI font used by Neovide
	vim.opt.guifont = "Iosevka Custom Light Extended:h13" -- Alternative: "Fira Code:h13".

	-- Floating window blur
	g.neovide_floating_blur_amount_x = 2.0
	g.neovide_floating_blur_amount_y = 2.0

	-- Global scaling (zoom) and keymaps to adjust it.
	g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		g.neovide_scale_factor = g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end, { desc = "Neovide: zoom in" })
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end, { desc = "Neovide: zoom out" })
end
