/// @description ??
if global.debug_ai {
	var old_halign = draw_get_halign()
	var old_alpha = draw_get_alpha()
	var old_font = draw_get_font()
	draw_set_alpha(0.2)
	draw_circle_color(x,y,global.grid_cell_width/2, player_colour, player_colour, false)
	draw_set_halign(fa_middle)
	draw_set_alpha(old_alpha)
	draw_set_font(font_stat_card_small)
	draw_text_color(x,y,player_name, c_white, c_white,c_white,c_white, 1)
	draw_set_halign(old_halign)
	draw_set_font(old_font)
}