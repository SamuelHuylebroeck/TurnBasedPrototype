/// @description ??
shader_set(sha_white_highlight)
var highlight_colour = c_white;
var highlight_mix =0.0
if highlighted {
	highlight_mix = 0.5
}
	
var highlight_colour_pass = [colour_get_red(highlight_colour)/255, colour_get_green(highlight_colour)/255 ,colour_get_blue(highlight_colour)/255,1];
shader_set_uniform_f_array(_highlight_colour ,highlight_colour_pass)
shader_set_uniform_f(_highlight_mix, highlight_mix)

draw_self()
shader_reset()