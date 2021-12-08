/// @description Draw player name
var old_font= draw_get_font()
var old_color = draw_get_color()

draw_set_color(player_name_colour)
draw_set_font(player_name_font)

draw_text(x,y,player_name);

draw_set_color(old_color)
draw_set_font(old_font)