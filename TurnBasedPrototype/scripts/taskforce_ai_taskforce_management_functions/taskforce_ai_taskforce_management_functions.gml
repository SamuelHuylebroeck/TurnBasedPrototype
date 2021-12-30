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

function placeholder_max_out_taskforce(ai_player, taskforce_template, max_count){
	//Current count
	var count = 0
	for (var i=0; i< ds_list_size(ai_player.ds_list_taskforces); i++){
		tf_type = ai_player.ds_list_taskforces[|i].object_index
		if tf_type == taskforce_template {
			count++
		}
		
	}
	//Max up count
	if count < max_count{
		repeat(max_count - count){
			var new_tf = instance_create_layer(0,0,"Taskforces", taskforce_template)
			with(new_tf){
				taskforce_player = ai_player 
			}
			
			with(ai_player){
				ds_list_add(ds_list_taskforces, new_tf)
			}
		}
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

function update_objectives_raider_taskforce(taskforce, ai_player){
	//Check if current objective is completed
	var complete = is_objective_completed(taskforce.current_objective, taskforce, ai_player)
	if (complete){
		with(taskforce){
			//if yes, pop and move on to next
			var next_objective = ds_queue_dequeue(ds_queue_taskforce_objectives)
			if next_objective != undefined{
				current_objective = next_objective
			}else{
				current_objective = noone
			}
			// if empty, get new objectives
			if ds_queue_empty(ds_queue_taskforce_objectives)
			{
				get_new_objective_raider_taskforce(self, ai_player)
				//Immediatly check if this has completed already
				update_objectives_raider_taskforce(self, ai_player)
			}
		}

	}
}
function update_objectives_all_raider_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Checking objective progress for Raider taskforces")
	//Loop over each taskforce
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_objectives_raider_taskforce(tf, ai_player)
	}
}

function update_objectives_defender_taskforce(ds_list_taskforces, ai_player){
	show_debug_message("Updating objectives for Defender taskforces")
}

function get_new_objective_raider_taskforce(taskforce, ai_player){
	//Loop over all economy buildings to get a list of targets
	var ds_scored_objectives = ds_priority_create()
	with(par_income_building){
		if controlling_player == noone or controlling_player.id != ai_player.id{
			var objective = new Objective(self.id, OBJECTIVE_TYPES.capture )
			var income_building_score = get_objective_score_raider_taskforce(objective, taskforce, ai_player)
			ds_priority_add(ds_scored_objectives, objective, income_building_score)
		}
	}
	//Loop over all production buildings to get a list of targets
	with(par_recruitment_building){
		if controlling_player == noone or controlling_player.id != ai_player.id{
			var objective = new Objective(self.id, OBJECTIVE_TYPES.capture )
			var recruitment_building_score = get_objective_score_raider_taskforce(objective, taskforce, ai_player)
			ds_priority_add(ds_scored_objectives, objective, recruitment_building_score)
		}
	}
	//Loop over all flags to add to the list of targets
	with(obj_flag){
		if controlling_player == noone or controlling_player.id != ai_player.id{
			var objective = new Objective(self.id, OBJECTIVE_TYPES.capture)
			var flag_building_score = get_objective_score_raider_taskforce(objective, taskforce, ai_player)
			ds_priority_add(ds_scored_objectives, objective, flag_building_score)
		}
	}
	if global.debug_ai and global.debug_ai_raider_taskforces
	{ 
		debug_dump_objective_queue_contents(ds_scored_objectives)
	}
	repeat(taskforce.objective_queue_max_size){
		var new_objective = ds_priority_delete_max(ds_scored_objectives)
		ds_queue_enqueue(taskforce.ds_queue_taskforce_objectives, new_objective)
	}
	
	ds_priority_clear(ds_scored_objectives)
	ds_priority_destroy(ds_scored_objectives)
}

function get_objective_score_raider_taskforce(objective, taskforce, ai_player){
	#region Explanation
	// - Favour objectives closer to home base
	// - Favour objectives in zone of interest
	// - Favour recruitment buildings over income over flags 
	// Score is abbbc, with a if the objective is in the zone of interest, b being the distance component, and c the type component
	#endregion
	var compound_score = 0
	// Get and scale zone of interest score
	var in_zone = floor(point_distance(taskforce.x, taskforce.y, objective.target.x, objective.target.y)/global.grid_cell_width) <= taskforce.zoi_tile_radius
	if in_zone {
		compound_score += 1000
	}
	// Get and scale distance_score
	var distance_to_home = point_distance(taskforce.home_x, taskforce.home_y, objective.target.x, objective.target.y)
	var max_map_distance = point_distance(0,0,room_width, room_height)
	var scaled_distance_to_home = distance_to_home / max_map_distance
	var distance_score = round((1-scaled_distance_to_home)*100)*10
	compound_score += distance_score
	//Get type scores
	var type_score =0
	var target_type = object_get_parent(objective.target.object_index)
	if target_type = -100 {
		target_type = objective.target.object_index
	}
	switch(target_type){
		case par_recruitment_building:
			type_score = 3
			break;
		case par_income_building:
			type_score = 2
			break;
		case obj_flag:
			type_score = 1
			break;
	}
	compound_score += type_score
	return compound_score
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