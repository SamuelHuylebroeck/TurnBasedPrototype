/// @description ??
var old_font = draw_get_font()
var old_colour = draw_get_color()
var old_valign = draw_get_valign()
var old_halign = draw_get_halign()
var old_alpha  = draw_get_alpha()

draw_set_font(message_font)
draw_set_color(message_colour)
draw_set_alpha(image_alpha)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

draw_text(x,y, message_text)


draw_set_font(old_font)
draw_set_color(old_colour)
draw_set_alpha(old_alpha)
draw_set_halign(old_halign)
draw_set_valign(old_valign)