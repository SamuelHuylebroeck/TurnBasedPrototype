//@description ??
function take_player_turn(){
	//Get the active player
	var active_player = get_current_active_player()
	
	//Select player unit
	if(instance_position(mouse_x, mouse_y,par_abstract_unit) and mouse_check_button_pressed(mb_left) and global.player_permission_selection)
	{
		var selection_candidate;
		selection_candidate = instance_position(mouse_x,mouse_y,par_abstract_unit);
		select(selection_candidate, active_player);
	}
		
	if(global.selected != noone and mouse_check_button_pressed(mb_right))
	{
		//Move
		var move_tile = instance_position(mouse_x,mouse_y,obj_move_possible)
		if( move_tile and global.player_permission_execute_orders)
		{
			global.moving = true;
			revoke_player_control()
			with(global.selected){
				var w = global.grid_cell_width;
				var h = global.grid_cell_height;
				var center_start = get_center_of_occupied_tile(global.selected);
				//var is_moving = navigate(global.selected, center_start[0],center_start[1],(floor(mouse_x/w))*w + w/2,floor(mouse_y/h)*h + h/2);
				var is_moving = navigate_astar(global.selected, move_tile.astar_path)
				if(is_moving)
				{
					move_points_pixels_curr -= path_get_length(global.navigate);
					move_points_curr -= ceil(move_tile.astar_path.cost)
				}
				current_state = UNIT_STATES.moving
			}
			clean_possible_moves();
			
			play_random_sound_from_array(global.selected.unit_sound_map[sound_map_keys.move])
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
				restore_player_control()
				is_moving = false;
				current_state = UNIT_STATES.idle
				if(move_points_curr >= 1 and !has_acted_this_round){
					//draw_possible_moves_selected();
					draw_possible_moves_selected_astar();
				}
			}
		
		}
	}

	//Keyboard triggers
	if global.player_permission_execute_orders
	{
		handle_mark_as_done()
		handle_select_next_available(active_player)
	}
}

function select(selection_candidate, active_player){
		#region select logic
		if(selection_candidate != noone and selection_candidate.id != global.selected and selection_candidate.controlling_player != noone and selection_candidate.controlling_player.id == active_player)
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
			
			//play unit selection sound
			if(!global.selected.has_acted_this_round)
			{
				play_random_sound_from_array(global.selected.unit_sound_map[sound_map_keys.select])
			}
		}	
		if(!move_grid_drawn && global.selected != noone && !global.selected.has_acted_this_round and global.player_permission_execute_orders){ 
			//draw_possible_moves_selected();
			draw_possible_moves_selected_astar();
		}
		
		//Select enemy unit
		if(selection_candidate != noone and selection_candidate.id != global.enemy_selected and (selection_candidate.controlling_player == noone or selection_candidate.controlling_player.id != active_player.id))
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
			gui_unit_stats.left_side = false
		}
		#endregion
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

function handle_mark_as_done()
{
		if	(
				global.selected != noone 
				and 
				(
					keyboard_check_pressed(ord(global.key_mark_unit_done)) 
					or keyboard_check_pressed(vk_rshift)
				)
			)
		{
			with(global.selected)
			{
				has_acted_this_round = true
			}
			deselect()	
		}
}

function handle_select_next_available(active_player)
{
	
	if(
		keyboard_check_pressed(ord(global.key_next_available_unit)) 
		or keyboard_check_pressed(vk_lshift)
	)
	{
		var next_available = get_next_available_unit(active_player)
		if(next_available != noone)
		{
			select(next_available, active_player);
			//Scroll or focus camera on unit's position
			pan_camera_to_center_on_position(global.selected.x,global.selected.y,0.2,true)
			
		}
	}

}

function get_next_available_unit(player)
{
	var max_units = ds_list_size(player.ds_active_units);
	
	var current_pos = global.selected == noone || ds_list_find_index(player.ds_active_units, global.selected)==-1 ?0: ds_list_find_index(player.ds_active_units, global.selected)
	var i = 0; while( i<max_units){
		current_pos = (current_pos+1)%max_units
		var candidate = player.ds_active_units[|current_pos]
		if (not candidate.has_acted_this_round)
		{
			return candidate
		}
		i++
	}
	return noone
}
