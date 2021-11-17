//@description ??
function take_player_turn(){
	//Get the active player
	var active_player = ds_turn_order[| current_active_player_index]
	
	//Select player unit
	if(instance_position(mouse_x, mouse_y,par_abstract_unit) and mouse_check_button_pressed(mb_left) and global.player_permission_selection)
	{
		var player_unit;
		player_unit = instance_nearest(mouse_x,mouse_y,par_abstract_unit);
		if(player_unit.id != global.selected and player_unit.controlling_player.id == active_player){
			global.selected=player_unit;
			clean_possible_moves();
		}	
		if(!move_grid_drawn && global.selected != noone && !global.selected.has_acted_this_round and global.player_permission_execute_orders){ 
			draw_possible_moves_selected();
		}
	}
		
	if(global.selected != noone and mouse_check_button_pressed(mb_right))
	{
		//Move
		if(instance_position(mouse_x,mouse_y,obj_move_possible) and global.player_permission_execute_orders)
		{
			global.moving = true;
		
			with(global.selected){
				var w = global.grid_cell_width;
				var h = global.grid_cell_height;
				var center_start = get_center_of_occupied_tile(global.selected);
				var is_moving = navigate(global.selected, center_start[0],center_start[1],(floor(mouse_x/w))*w + w/2,floor(mouse_y/h)*h + h/2);
				if(is_moving)
				{
					move_points_pixels_curr -= path_get_length(global.navigate);
				}
			}
			clean_possible_moves();
		}else{
			deselect();
		}
	}
		
	if (global.selected == noone and mouse_check_button_pressed(mb_right) and global.player_permission_selection ) {
		deselect()
	}
	
	if(global.moving)
	{	
		with(global.selected)
		{
			if(path_index == -1)
			{
				global.moving = false;
				is_moving = false;
				if(move_points_pixels_curr >= global.grid_cell_width && !has_acted_this_round){
					draw_possible_moves_selected();
				}
			}
		
		}
	}

}
	
	
function deselect() {
	if(global.moving == false){
		global.selected = noone;
		clean_possible_moves();
	}
}
