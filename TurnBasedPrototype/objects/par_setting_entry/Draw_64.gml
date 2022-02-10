/// @description ??
var text_width = string_width(entry_text)
var x_margin = 0
var setting_font = font_menu_big
var font_color = c_soft_yellow
var scale = 1

var old_halign = draw_get_halign()
var old_valign = draw_get_valign()
var old_font = draw_get_font()
var old_colour = draw_get_colour()



draw_set_halign(fa_right)
draw_set_valign(fa_middle)
draw_set_font(setting_font)
draw_set_color(font_color)

draw_text(x,y, entry_text)
//draw_circle(x,y,5, true)

draw_set_halign(old_halign)
draw_set_valign(old_valign)
draw_set_colour(old_colour)
draw_set_font(old_font)