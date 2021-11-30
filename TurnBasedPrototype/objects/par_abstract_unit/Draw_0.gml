/// @description Shaders
if (controlling_player != noone) {
	shader_set(sha_team_colour_blend)
	var player_colour= controlling_player.player_colour;
	var pass_colour = [colour_get_red(player_colour)/255, colour_get_green(player_colour)/255 ,colour_get_blue(player_colour)/255,1];
	var mix = 0.6
	shader_set_uniform_f(_tc_mix, mix)
	shader_set_uniform_f_array(_team_colour, pass_colour)
	
	var highlight_colour = c_white;
	var highlight_mix =0.0
	
	if (has_acted_this_round){
		highlight_mix =0.5
		highlight_colour = c_black
	}
	
	var highlight_colour_pass = [colour_get_red(highlight_colour)/255, colour_get_green(highlight_colour)/255 ,colour_get_blue(highlight_colour)/255,1];
	shader_set_uniform_f_array(_highlight_colour ,highlight_colour_pass)
	shader_set_uniform_f(_highlight_mix, highlight_mix)

}
draw_self();
shader_reset();