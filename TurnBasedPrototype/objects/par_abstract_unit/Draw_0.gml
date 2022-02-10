/// @description Shaders and healthbar
if (controlling_player != noone) {
	shader_set(sha_team_colour_blend)
	var player_colour= controlling_player.player_colour;
	var pass_colour = [colour_get_red(player_colour)/255, colour_get_green(player_colour)/255 ,colour_get_blue(player_colour)/255,1];
	var mix = 0.33
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

#region healthbar
var damaged = current_hp < unit_profile.max_hp

if (
	global.draw_healthbars == draw_healthbar_condition.always 
	or (damaged and global.draw_healthbars == draw_healthbar_condition.damaged_only)
	)
{
	var hp_percent = clamp(current_hp / unit_profile.max_hp, 0, 1)
	var hb_w = 48
	var hb_h = 4
	var y_offset = global.grid_cell_height/2
	draw_set_color(c_red)
	draw_rectangle(x-hb_w/2, y+y_offset, x+hb_w/2, y+y_offset+hb_h, false)
	draw_set_color(c_soft_light_blue)
	draw_rectangle(x-hb_w/2, y+y_offset, x-hb_w/2+hp_percent* hb_w, y+y_offset+hb_h, false)
}

#endregion