/// @description ??
var old_halign = draw_get_halign()
var old_font= draw_get_font()
var old_color = draw_get_color()

draw_set_color(text_colour)
draw_set_font(text_font)
draw_set_halign(fa_middle)
draw_text(x+sprite_width/2,y,text_contents);

draw_set_halign(old_halign)
draw_set_color(old_color)
draw_set_font(old_font)