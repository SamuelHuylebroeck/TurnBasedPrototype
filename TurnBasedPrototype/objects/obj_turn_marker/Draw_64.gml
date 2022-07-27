/// @description ??
if(global.map_running){
	
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	var x_scale = global.ui_scale_values[global.current_ui_scale][0]
	var y_scale = global.ui_scale_values[global.current_ui_scale][1]
	
	var margin = x_scale * base_margin
	
	var current_round = control.current_round
	var current_index = control.current_active_player_index % ds_list_size(control.ds_turn_order)
	var player = control.ds_turn_order[| current_index]
	var player_name = player.player_name
	var flags_to_win = control.flags_to_win
	var current_pos_x = display_get_gui_width()/2;
	var current_pos_y = margin;
	var old_align = draw_get_halign();
	

	
	var turn_text = "Round: " + string(current_round) + " - Player: " + string(player_name);
	draw_set_font(fonts[2]);
	var tt_w = string_width(turn_text) + 2* margin
	var tt_h = string_height(turn_text)
	
	draw_set_font(fonts[1]);
	var resource_text = "Flags: "+ string(player.player_current_flag_total)+"/"+string(flags_to_win)+"- Resources: "+ string(player.player_current_resources) + "("+string(player.current_income)+")"; 
	var rt_h = string_height(resource_text)
	
	var width = clamp(tt_w, x_scale * base_width, max_gui_width*display_get_gui_width())
	var height = clamp(tt_h + rt_h + 2*margin,  y_scale * base_height, max_gui_heigth*display_get_gui_height())

	
	draw_sprite_stretched(spr_frame,0,current_pos_x-width/2,current_pos_y,width,height)

	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_middle);
	draw_set_font(fonts[2]);
	draw_set_color(text_color);
	draw_set_alpha(1);
	
	draw_text(current_pos_x,current_pos_y+margin,turn_text);
	var tt_h = string_height(turn_text)
	
	draw_set_font(fonts[0]);
	
	draw_text(current_pos_x,current_pos_y+tt_h+margin,resource_text);
	
	
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}