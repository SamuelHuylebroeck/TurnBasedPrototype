var fonts = global.ui_scale_values[global.current_ui_scale][2]
var x_scale = global.ui_scale_values[global.current_ui_scale][0]
var y_scale = global.ui_scale_values[global.current_ui_scale][1]
draw_set_color(c_soft_yellow)
//draw_rectangle(ui_x, ui_y, ui_x+max_width, ui_y+max_height, true);

#region drawing variable save
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();
var old_font = draw_get_font();
var old_color = draw_get_color();
#endregion
if(initialized)
{
	width = max_width - 2*inner_frame_margin
	height = max_height - 2*inner_frame_margin
	var tl_x = ui_x + inner_frame_margin
	var tl_y = ui_y + inner_frame_margin
	//draw_rectangle(tl_x, tl_y, tl_x+width, tl_y+height, true);
	#region preview Sprite
	if(profile != noone)
	{
		var available_sprite_width = width/2
		var available_sprite_height= height/2
		
		draw_sprite_stretched(spr_frame,0,tl_x, tl_y, available_sprite_width, available_sprite_height)		
				
		var sprite_scale_x = floor(available_sprite_width/sprite_get_width(profile.preview_sprite))
		var sprite_scale_y = floor(available_sprite_height/sprite_get_height(profile.preview_sprite))
		var sprite_scale = min(sprite_scale_x, sprite_scale_y)
		
		frame_counter= (frame_counter + sprite_get_speed(profile.preview_sprite)/game_get_speed(gamespeed_fps))%sprite_get_number(profile.preview_sprite)
		
		shader_set(sha_team_colour_blend)
		var player_colour= recruiting_player.player_colour;
		var pass_colour = [colour_get_red(player_colour)/255, colour_get_green(player_colour)/255 ,colour_get_blue(player_colour)/255,1];
		var mix = 0.33
		shader_set_uniform_f(_tc_mix, mix)
		shader_set_uniform_f_array(_team_colour, pass_colour)
		
		draw_sprite_ext(profile.preview_sprite,frame_counter, tl_x+available_sprite_width/2, tl_y+available_sprite_height/2, sprite_scale, sprite_scale, 0, c_white,1)
		
		shader_reset()
	}
	#endregion
	
	#region name and unit stats
	preview_draw_unit_stats_block(tl_x+available_sprite_width,tl_y, available_sprite_width, available_sprite_height, fonts, profile.complete_profile.unit_profile)
	#endregion
	
	#region attack stats
	preview_draw_attack_stats_block(tl_x,tl_y+height/2, width/2, height*7/20, fonts, profile.complete_profile.attack_stats_profile)
	#endregion
	#region weather stats
	preview_draw_weather_stats_block(tl_x+width/2,tl_y+height/2, width/2, height*7/20, fonts, profile.complete_profile.weather_profile)
	#endregion
	#region description
	preview_draw_descriptions_block(tl_x,tl_y+height*17/20, width, height*3/20, fonts,profile.description )
	#endregion
}
#region drawing variables restore
draw_set_font(old_font);
draw_set_color(old_color);
draw_set_halign(old_halign);
draw_set_valign(old_valign);
#endregion