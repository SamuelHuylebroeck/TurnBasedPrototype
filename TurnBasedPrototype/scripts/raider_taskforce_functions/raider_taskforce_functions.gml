#region creation
#endregion
#region recruitment
function get_raider_taskforce_recruitment_request(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		var windsword_odds = 0.7
		var flip = random(1)
		var unit_template = obj_unit_flamesword
		if flip < windsword_odds{
			unit_template = obj_unit_windsword
		}
		var placeholder_request = {
			template: unit_template,
			tf: taskforce
		}
		ds_queue_enqueue(ds_request_queue, placeholder_request)
	}
}
#endregion
#region management
function update_objectives_all_raider_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Updating Raider taskforces")
	//Loop over each taskforce
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_taskforce_stance(tf, ai_player)
		update_objectives_raider_taskforce(tf, ai_player)
		update_taskforce_home_area(tf, ai_player)
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


#endregion
#region scoring
function raider_taskforce_action_scoring_function(action_type, unit, tile, taskforce, target){
	switch(taskforce.taskforce_stance){
		case TASKFORCE_STANCES.mustering:
			return generic_taskforce_score_mustering(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.retreating:
			return generic_taskforce_score_retreating(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.advancing:
		default:
			return raider_taskforce_score_advancing(action_type, unit, tile,taskforce,target)
	}
}

function raider_taskforce_score_advancing(action_type, unit, tile, taskforce, target){
		#region Score explanation
		//ABBBBCC
		//A is 6 if the move target of the tile is the objective, 5 otherwise
		//BBBB is the remaining path distance towards the objective, from the target tile, ignoring all units
		//CC is the action score on the tile, with 20 being no action. Skill can take prioirity over attack if enough more targets are effected
		//DD is the defensive score of the tile, with 50 being a neutral tile
		#endregion
		#region digit config
		var distance_digits = 3
		var action_digits = 2
		var defense_digits = 2
		#endregion
		var final_score = 0
		var objective_component = 5
		var  tile_is_objective = (tile._x == taskforce.current_objective.target.x and tile._y == taskforce.current_objective.target.y)
		if tile_is_objective {
			objective_component = 6
			show_debug_message("Target is objective")
		}
		var distance_to_objective_component =raider_taskforce_score_distance_to_objective(unit,tile,taskforce,distance_digits)
		var action_component

		switch(action_type){
		case ACTION_TYPES.move_and_attack:
			action_component = raider_taskforce_score_attack(unit, tile, taskforce,target, action_digits)
			break;
		case ACTION_TYPES.move_and_skill:
			action_component = raider_taskforce_score_skill(unit, tile, taskforce, action_digits)
			break;
		default:
			action_component = 0.2 * power(10,action_digits)
			break;
	
		}

		var defense_component = generic_taskforce_score_tile_defense(unit, tile, defense_digits)
		final_score = defense_component 
		final_score += power(10, defense_digits)*action_component
		final_score += power(10,defense_digits + action_digits)*distance_to_objective_component
		final_score += power(10,defense_digits + action_digits+distance_digits)*objective_component
		if global.debug_ai_raider_taskforces_scoring {
			var action_string = "Move"
			switch(action_type){
				case ACTION_TYPES.move_and_skill:
					action_string = "Skill"
					break;
				case ACTION_TYPES.move_and_attack:
					action_string = "Attack: " + string(floor(target._x/global.grid_cell_width))+","+string(floor(target._y/global.grid_cell_width))
					break;
				default:
					break;
			}
			show_debug_message("["+string(floor(tile._x/global.grid_cell_width))+","+string(floor(tile._y/global.grid_cell_height))+ "] - " + action_string)
			show_debug_message("Score: "+string(final_score))
		}
		return final_score
}

function raider_taskforce_score_distance_to_objective(unit, tile, taskforce, nr_digits){
	var objective_x = taskforce.current_objective.target.x
	var objective_y = taskforce.current_objective.target.y
	//Calculate length of path from tile to objective, ignoring all units
	mp_grid_clear_all(global.map_grid)
	add_impassible_tiles_to_grid(unit,false, false)
	var path_length = get_path_length(global.map_grid,global.navigate, tile._x,tile._y, objective_x, objective_y)
	var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.grid_cell_width
	var rel_objective_distance_score = (max_distance-(path_length))/max_distance 
	rel_objective_distance_score = clamp(floor(rel_objective_distance_score* power(10,nr_digits)),0,power(10,nr_digits)-1) 
	
	return rel_objective_distance_score
}

function raider_taskforce_score_attack(unit,tile, taskforce,target, nr_digits){
	var maximum_damage = get_attack_damage_ceiling(unit, tile, target,unit.attack_profile)
	var expected_damage = get_attack_expected_damage(unit, tile, target,unit.attack_profile,-1.1)
	var rel_expected_damage = expected_damage/maximum_damage
	//Put extra importance on clearing out an objective 
	var  target_on_objective = (target._x == taskforce.current_objective.target.x and target._y == taskforce.current_objective.target.y)
	
	if target_on_objective
	{
		rel_expected_damage = 0.9
	} 
	
	if (global.debug_ai_raider_taskforces_scoring) show_debug_message(string(expected_damage)+"/"+string(maximum_damage)+":"+string(rel_expected_damage)+" - CO: " +string(target_on_objective))
	
	
	//Rescale from [0,1] to [0,8*10^digits]
	rel_expected_damage = clamp(rel_expected_damage,0,1)
	if rel_expected_damage > 0 {
		rel_expected_damage = rel_expected_damage * (0.8)*power(10,nr_digits)
		rel_expected_damage += 0.2*power(10,nr_digits)
	}else{
		rel_expected_damage = 0.2*power(10,nr_digits)-1
	}
	
	var rel_attack_score = clamp(floor(rel_expected_damage),0,power(10,nr_digits)-1) 
	return rel_attack_score
}
function raider_taskforce_score_skill(unit,tile, taskforce, nr_digits){
	#region scoring explanation
	//A weather effect can have either friendly(boon) or enemy prefered targets
	//Each preferred target counts as a half a full power attack
	//Each non-preferred target substracks half a full power attack in score
	//Only apply score for tiles that have the skill effect terrain linger, refresh or detonate
	#endregion
	var sum_preferred_targets =  get_sum_preferred_targets(unit,tile,unit.weather_profile)
	var skill_score = sum_preferred_targets*1/2*unit.attack_profile.base_damage
	var max_skill_score = get_attack_damage_ceiling(unit,tile,tile,unit.attack_profile)
	var rel_skill_score = clamp(skill_score/max_skill_score,0,1)
	if (global.debug_ai_raider_taskforces_scoring) show_debug_message(string(sum_preferred_targets) + "," + string(skill_score)+"/"+string(max_skill_score)+":"+string(rel_skill_score))
	//Rescale from [0,1] to [0,8*10^digits]
	if rel_skill_score > 0 {
		rel_skill_score = rel_skill_score * (0.8)*power(10,nr_digits)
		rel_skill_score += 0.2*power(10,nr_digits)
	}else{
		rel_skill_score = 0.2*power(10,nr_digits)-1
	}
	rel_skill_score = clamp(floor(rel_skill_score),0,power(10,nr_digits)-1) 
	return rel_skill_score
}
#endregion

