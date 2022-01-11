/// @description ??
if global.debug_ai_defender_taskforces {
	var old_halign = draw_get_halign()
	var old_alpha = draw_get_alpha()
	var old_font = draw_get_font()
	draw_set_alpha(0.1)
	draw_circle_color(x,y,garrison_objective_tile_radius*global.grid_cell_width, c_yellow, c_yellow, false)
	draw_set_alpha(0.2)
	draw_circle_color(x,y,global.grid_cell_width/2, c_yellow, c_yellow, false)
	draw_set_halign(fa_middle)
	draw_set_alpha(1)
	draw_set_font(font_attack_preview)
	draw_text_color(x,y,"GOT " + string(id), c_white, c_white,c_white,c_white, 1)
	draw_set_alpha(old_alpha)
	draw_set_halign(old_halign)
	draw_set_font(old_font)
}