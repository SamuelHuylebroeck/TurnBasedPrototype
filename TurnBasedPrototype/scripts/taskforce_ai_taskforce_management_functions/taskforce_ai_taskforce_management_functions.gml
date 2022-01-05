//@description 
function max_out_taskforce(ai_player, taskforce_template, max_count){
	switch(taskforce_template){
		case obj_raider_taskforce:
			max_out_raider_taskforces_radial_distribution(ai_player, max_count)
			break;
		default:
			placeholder_max_out_taskforce(ai_player, taskforce_template, max_count);
			break;
	}
}


function update_objectives(ai_player, taskforce_type, ds_list_taskforces){
	show_debug_message("Updating objectives for taskforces of type " + string(taskforce_type))
	switch(taskforce_type){
		case obj_raider_taskforce:
			update_objectives_all_raider_taskforces(ds_list_taskforces, ai_player)
			break;
		case obj_defender_taskforce:
			update_objectives_defender_taskforce(ds_list_taskforces, ai_player)
			break;
		default:
			show_debug_message("Taskforces of type " + string(taskforce_type) + " do not have an objective function yet")
			
	}

}

function update_objectives_taskforce(taskforce, ai_player){
	switch(taskforce.object_index){
		case obj_raider_taskforce:
			update_objectives_raider_taskforce(taskforce, ai_player)
			break;
		default:
			show_debug_message("Taskforce of type " + string(taskforce.taskforce_type) + " does not have an objective update function yet")
			
	}

}


function update_objectives_defender_taskforce(ds_list_taskforces, ai_player){
	show_debug_message("Updating objectives for Defender taskforces")
}

function is_objective_completed(objective, taskforce, ai_player){
	if objective == noone{
		return true
	}
		
	switch (objective.objective_type){
		case OBJECTIVE_TYPES.capture:
			return is_capture_objective_completed(objective, taskforce, ai_player)
	}
}

function is_capture_objective_completed(objective, taskforce, ai_player){
	var objective_already_captured = objective.target.controlling_player != noone and objective.target.controlling_player.id == ai_player.id
	var objective_will_be_captured = false
	var unit_at_position = instance_position(objective.target.x, objective.target.y , par_abstract_unit)
	if unit_at_position != noone{
		objective_will_be_captured = (unit_at_position.controlling_player!=noone and unit_at_position.controlling_player.id == ai_player.id)
	}	
	return objective_already_captured or objective_will_be_captured

}

function debug_dump_objective_queue_contents(objective_queue){
	show_debug_message("---Dumping objective queue---")
	var copied_queue = ds_priority_create()
	ds_priority_copy(copied_queue, objective_queue)
	while(not ds_priority_empty(copied_queue)){
		var current_max = ds_priority_find_max(copied_queue)
		var current_max_priority = ds_priority_find_priority(copied_queue, current_max)
		var s = string(current_max_priority) + ": " + string(current_max.target.object_index)+" - " + string(current_max.target.id)
		show_debug_message(s)
		ds_priority_delete_max(copied_queue)
	
	}
	ds_priority_destroy(copied_queue)
	show_debug_message("---End of dump---")

}
	
function update_taskforce_stance(tf, ai_player){
	with(tf){
		var current_taskforce_size = ds_list_size(ds_list_taskforce_units)
		var c_rel_size = current_taskforce_size / taskforce_max_size
		switch(taskforce_stance){
			case TASKFORCE_STANCES.advancing:
				if c_rel_size <= taskforce_retreat_threshold{
					taskforce_stance = TASKFORCE_STANCES.retreating
				}
				break;
			case TASKFORCE_STANCES.mustering:
				if c_rel_size >= taskforce_advance_threshold {
					taskforce_stance = TASKFORCE_STANCES.advancing
				}
				break;
			case TASKFORCE_STANCES.retreating:
				var counter = 0
				var units_near_home = ds_list_create()
				for(var i=0; i<ds_list_size(ds_list_taskforce_units);i++){
					var unit = ds_list_taskforce_units[|i]
					if point_distance(home_x,home_y,unit.x,unit.y) <= taskforce_homezone_tile_radius*global.grid_cell_width
					{
						counter++
					}
				}
				ds_list_destroy(units_near_home)
				if counter/taskforce_max_size >= taskforce_retreat_end_threshold{
					taskforce_stance = TASKFORCE_STANCES.mustering
				}
				break;	
	
		}
	}
}

function update_taskforce_home_area(tf, ai_player){
	//Select the recruitment building closest to the current objective
	var closest_recruitment_building = get_closest_controlled_recruitment_building(tf.current_objective.target.x, tf.current_objective.target.y, ai_player)
	tf.home_x = closest_recruitment_building.x
	tf.home_y = closest_recruitment_building.y

}