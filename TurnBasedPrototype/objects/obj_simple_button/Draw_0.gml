/// @description ??
draw_self()
var old_halign = draw_get_halign()
var old_valign = draw_get_valign()
var old_font= draw_get_font()
var old_color = draw_get_color()

draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_color(button_text_current_colour)
draw_set_font(button_text_font)

draw_text(x+sprite_width/2,y+sprite_height/2,button_text);
draw_set_halign(old_halign)
draw_set_valign(old_valign)
draw_set_color(old_color)
draw_set_font(old_font)