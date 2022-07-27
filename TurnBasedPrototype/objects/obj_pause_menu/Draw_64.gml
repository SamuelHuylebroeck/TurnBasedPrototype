/// @description ??
if not global.in_game_pause_menu_active exit;
var c_background = c_black
draw_sprite_stretched(spr_frame,0,0.2*global.ui_width,0.1*global.ui_height,0.6*global.ui_width,0.8*global.ui_height)

var old_colour = draw_get_color()
draw_set_color(c_background)

draw_rectangle(0.495*global.ui_width, 0.2 * global.ui_height, 0.505*global.ui_width, 0.2*global.ui_height+vertical_seperator_height, false)

draw_set_color(old_colour)