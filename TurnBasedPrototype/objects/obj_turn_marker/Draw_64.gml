/// @description ??
if(global.map_running){
	var turn = control.current_turn
	var current_index = control.current_active_player_index % ds_list_size(control.ds_turn_order)
	var player = control.ds_turn_order[| current_index]
	var player_name = player.player_name
	var current_pos_x = view_get_wport(view_current)/2 + view_get_xport(view_current);
	var current_pos_y = y_offset;
	var old_align = draw_get_halign();
	
	draw_set_halign(fa_left);
	draw_sprite_stretched(spr_frame,0,current_pos_x,current_pos_y,384,96)

	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_font(text_font);
	draw_set_color(text_color);
	draw_set_alpha(1);
	var turn_text = "Turn: " + string(turn) + " - Player: " + string(player_name) ;
	draw_text(current_pos_x+5,current_pos_y+5,turn_text);

	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}