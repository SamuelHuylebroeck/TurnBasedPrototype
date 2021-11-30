//@description ??
function take_player_turn(){
	//Get the active player
	var active_player = get_current_active_player()
	
	//Select player unit
	if(instance_position(mouse_x, mouse_y,par_abstract_unit) and mouse_check_button_pressed(mb_left) and global.player_permission_selection)
	{
		var selection_candidate;
		selection_candidate = instance_nearest(mouse_x,mouse_y,par_abstract_unit);
		if(selection_candidate.id != global.selected and selection_candidate.controlling_player.id == active_player)
		{
			//delete old stat card
			with(obj_gui_unit_stat_card)
			{
				if (self.unit == global.selected){
					instance_destroy();
				}
			}
			
			global.selected=selection_candidate;
			clean_possible_moves();
			
			//Create unit stats view
			var gui_unit_stats = instance_create_layer(0,0,"UI", obj_gui_unit_stat_card);
			gui_unit_stats.unit = global.selected;
		}	
		if(!move_grid_drawn && global.selected != noone && !global.selected.has_acted_this_round and global.player_permission_execute_orders){ 
			draw_possible_moves_selected();
		}
		
		//Select enemy unit
		if(selection_candidate.id != global.enemy_selected and selection_candidate.controlling_player.id != active_player)
		{
			var enemy_unit = selection_candidate
			//delete old stat card
			with(obj_gui_unit_stat_card)
			{
				if (self.unit == global.enemy_selected){
					instance_destroy();
				}
			}
			global.enemy_selected=enemy_unit;
			//Create unit stats view
			var gui_unit_stats = instance_create_layer(0,0,"UI", obj_gui_unit_stat_card);
			gui_unit_stats.unit = global.enemy_selected;
			//TODO remove magic number
			gui_unit_stats.screen_offset_x += 1300
			
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
				current_state = UNIT_STATES.moving
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
				current_state = UNIT_STATES.idle
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
		with(obj_gui_unit_stat_card){
			instance_destroy();
		}
	}
}
