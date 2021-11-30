/// @description ??
if(global.map_running){
	var current_round = control.current_round
	var current_index = control.current_active_player_index % ds_list_size(control.ds_turn_order)
	var player = control.ds_turn_order[| current_index]
	var player_name = player.player_name
	var current_pos_x = display_get_gui_width()/2;
	var current_pos_y = y_offset;
	var old_align = draw_get_halign();
	
	var width = 420
	var height = 96
	
	draw_sprite_stretched(spr_next_turn_button,0,current_pos_x-width/2,current_pos_y,width,height)

	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_middle);
	draw_set_font(text_font);
	draw_set_color(text_color);
	draw_set_alpha(1);
	var turn_text = "Round: " + string(current_round) + " - Player: " + string(player_name);
	draw_text(current_pos_x,current_pos_y+8,turn_text);
	
	var resource_text = "Resources: " + string(player.player_current_resources); 
	draw_text(current_pos_x,current_pos_y+8+string_height(resource_text),resource_text);
	
	
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}