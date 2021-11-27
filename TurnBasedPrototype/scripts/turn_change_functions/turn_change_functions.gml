//@description ??
function goto_next_turn(){
	deselect()
	resolve_turn_end(ds_turn_order[| current_active_player_index])
	//Advance to next player
	current_active_player_index++
	if (current_active_player_index>=ds_list_size(ds_turn_order)){
		current_active_player_index = current_active_player_index%ds_list_size(ds_turn_order)
		current_round++
		resolve_round_end()
	}
	resolve_turn_start(ds_turn_order[| current_active_player_index])
}

function resolve_turn_start(player){
	if (player != noone){
		//Loop over weather and have them take effect
		
		//Loop over every unit
		with(par_abstract_unit){
			if(controlling_player != noone and controlling_player.id == player.id){
				resolve_turn_start_unit(self)
			}
	
		}
	}
}

function resolve_turn_start_unit(unit){
	show_debug_message("Resolving unit start of turn")
	//Prep movement
	unit.move_points_total_current = unit.unit_profile.base_movement
	
	
	#region Terrain effect
	var weather = instance_place(unit.x, unit.y ,par_weather)
	
	if weather != noone {
		resolve_weather_start_of_turn(unit, weather)
	
	}
	#endregion
	
	#region weather
	
	var terrain = instance_place(unit.x, unit.y ,par_terrain)
	
	if terrain != noone {
		resolve_terrain_start_of_turn(unit, terrain)
	
	}
	#endregion
	
	#region boons and banes
	if (ds_map_size(unit.ds_boons_and_banes) > 0)
	{
		var boons_and_banes = ds_map_values_to_array(unit.ds_boons_and_banes)
		var to_remove = ds_list_create()
		//Boon and bane effect
		for (var i = 0; i< array_length(boons_and_banes); i++)
		{
			var boon_bane = boons_and_banes[i]
			
			var done = boon_bane.Apply(unit)
			if done
			{
				ds_list_add(to_remove, boon_bane.verbose_name)
			}
		}
		//Boon and bane removal
		for (var i= 0; i< ds_list_size(to_remove); i++)
		{
			var key = to_remove[| i]
			show_debug_message("Removing " + string(key) + " from " + string(unit.id))
			ds_map_delete(unit.ds_boons_and_banes, key)
		}
		ds_list_destroy(to_remove)
	}
	#endregion

	//Stat refresh
	refresh_movement(unit)

}

function resolve_turn_end(player){
	if (player != noone){
		//Loop over every unit
		with(par_abstract_unit){
			if(controlling_player != noone and controlling_player.id == player.id){
				//Remove activation marker
				has_acted_this_round = false;
			}
		}
	}

}

function refresh_movement(unit){
	unit.move_points_pixels_curr = unit.move_points_total_current*global.grid_cell_width
}

function resolve_round_end(){
	//Resolve weather effects
	with(par_weather){
		current_duration--
		if(current_duration <=0){
			fade_weather()
		}
	
	}
	//Check for EoG scoring

}