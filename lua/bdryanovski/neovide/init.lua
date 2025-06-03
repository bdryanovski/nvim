if vim.g.neovide then
	local g = vim.g

	g.neovide_text_gamma = 0.0
	g.neovide_text_contrast = 0.5

	g.neovide_padding_top = 0
	g.neovide_padding_bottom = 0
	g.neovide_padding_right = 0
	g.neovide_padding_left = 0

	g.neovide_scroll_animation_length = 0.2
	g.neovide_scroll_animation_far_lines = 1
	g.neovide_hide_mouse_when_typing = false
	g.neovide_refresh_rate = 60
	g.neovide_refresh_rate_idle = 5
	-- g.neovide_remember_window_size = true
	g.neovide_profiler = false
	-- g.neovide_cursor_animation_length = 0.08
	g.neovide_cursor_trail_size = 0.8
	g.neovide_cursor_antialiasing = true
	g.neovide_cursor_vfx_mode = "ripple"
	g.neovide_fullscreen = false

	vim.opt.guifont = "Iosevka Term SS10:h15" -- Fira Code:h13

	g.neovide_floating_blur_amount_x = 2.0
	g.neovide_floating_blur_amount_y = 2.0

	g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		g.neovide_scale_factor = g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end)
end
