/// @description Shaders

if (controlling_player != noone) {
	shader_set(sha_team_colour_blend)
	var player_colour= controlling_player.player_colour;
	var pass_colour = [colour_get_red(player_colour)/255, colour_get_green(player_colour)/255 ,colour_get_blue(player_colour)/255,1];
	var player_colour = []
	//var pass_colour = [colour_get_red(player_colour), colour_get_green(player_colour) ,colour_get_blue(player_colour),1];
	var mix =0.5
	shader_set_uniform_f(_tc_mix, mix)
	shader_set_uniform_f_array(_team_colour, pass_colour)
}


if(has_acted_this_round)
{
	shader_set(sha_grayscale);
	image_speed = 0.5;
}else
{
	image_speed = 1;
}
draw_self();
shader_reset();