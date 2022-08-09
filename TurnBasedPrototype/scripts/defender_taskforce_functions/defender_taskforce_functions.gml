#region creation
function update_defender_taskforce_distribution(ai_player, max_count){
	//Current count
	var count = 0
	for (var i=0; i< ds_list_size(ai_player.ds_list_taskforces); i++){
		var tf_type = ai_player.ds_list_taskforces[|i].object_index
		if tf_type == obj_defender_taskforce {
			count++
		}
		
	}
	
	//Loop over all
	with(obj_garrison_objective_tracker)
	{
		if is_garrison_objective_under_player_control(self, ai_player) and ds_map_find_value(map_assigned_taskforces, ai_player.id) == undefined
		{
			//This one is a potential new taskforce
			if count < max_count {
				//Create new defender taskforce and add it to the map
				var tf = create_defender_taskforce(self, ai_player)
				ds_map_add(map_assigned_taskforces, ai_player.id, tf)
				count++
			}
		}	
	
	}

}

function is_garrison_objective_under_player_control(go_tracker, player){
	with(go_tracker){
		for(var i=0; i <ds_list_size(list_nearby_structures);i++)
		{
			var structure = list_nearby_structures[|i]
			if structure.controlling_player == noone or structure.controlling_player.id != player.id 
			{
				return false
			}
		}
	}
	return true

}
#endregion

function create_defender_taskforce(garrison_objective_tracker,  taskforce_player){
	//Get the closest owned recruitment building
	var tf = instance_create_layer(garrison_objective_tracker.x, garrison_objective_tracker.y,"Taskforces", obj_defender_taskforce)
	var closest_recruitment_building = get_closest_controlled_recruitment_building(tf.x, tf.y, taskforce_player)
	with(tf){
		self.home_x = closest_recruitment_building.x
		self.home_y = closest_recruitment_building.y
		self.taskforce_player = taskforce_player
		self.taskforce_max_size = ds_list_size(garrison_objective_tracker.list_nearby_structures)+2
		var new_obj = new Objective(garrison_objective_tracker, OBJECTIVE_TYPES.guard)
		self.current_objective = new_obj
	}
	with(taskforce_player){
		ds_list_add(ds_list_taskforces, tf)
	}
	return tf
}
#region recruitment
function get_defender_taskforce_recruitment_request(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		var choice = choose(obj_unit_groundpounder, obj_unit_waveaxe, obj_unit_captain_knight, obj_unit_groundsplitter, obj_unit_pyroarcher, obj_unit_shardslinger)
		var placeholder_request = {
			verbose_name: "Defender Req: " + string(choice),
			template: choice,
			tf: taskforce
		}
		ds_queue_enqueue(ds_request_queue, placeholder_request)
	}
}
#endregion
#region management
function update_objectives_all_defender_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Updating Defender taskforces")
	//Loop over each taskforce
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_taskforce_stance(tf, ai_player)
		update_objectives_defender_taskforce(tf, ai_player)
		update_taskforce_home_area(tf, ai_player)
	}
}

function update_objectives_defender_taskforce(taskforce, ai_player){
	//Check if current objective is completed
	var complete = is_objective_completed(taskforce.current_objective, taskforce, ai_player)
	if (complete){
		with(taskforce){
			//if yes, this means we must retreat
			taskforce_stance = TASKFORCE_STANCES.retreating
		}
	}

}
#endregion

#region scoring
function defender_taskforce_action_scoring_function(action_type, unit, tile, taskforce, target){
	switch(taskforce.taskforce_stance){
		case TASKFORCE_STANCES.mustering:
			return generic_taskforce_score_mustering(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.retreating:
			return generic_taskforce_score_retreating(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.advancing:
		default:
			return defender_taskforce_score_advancing(action_type, unit, tile,taskforce,target)
	}
}

function defender_taskforce_score_advancing(action_type, unit, tile, taskforce, target){
		#region Score explanation
		//ABBBBCCDDEE
		//A is the objective score, scoring as follows
		// 8 if the tile contains a structure that is part of the objective 
		// 7 if the tile contains a structure
		// 7 if the tile is in the objective zone and the target stands on top of an objective
		// 6 if the tile is in the objective zone and the target of the attack is as well
		// 4 if the tile is in the objective zone and the target of an attack is outside
		// 4 if the tile is in the objective zone for a move or skill
		// 4 if the tile contains a capturable building and is not in the obbjective zone
		// 2 if the tile is not in the objective zone
		// BBBB is the remaining path distance towards the objective, from the target tile, ignoring all units. If the tile is in the objective zone, this score is maxed out
		// CC is the action score on the tile, with 20 being no action. Skill can take prioirity over attack if enough more targets are effected
		// DD is the defensive score of the tile
		#endregion
		#region digit config
		var distance_digits = 3
		var action_digits = 2
		var defense_digits = 2
		#endregion
		var final_score = 0
		var defense_radius = taskforce.current_objective.target.garrison_objective_tile_radius
		var objective_component = defender_taskforce_score_objective_advancing(action_type,unit,tile,taskforce, target)
		
		var distance_to_objective_component =generic_taskforce_score_distance_to_zone(unit,tile,taskforce, taskforce.current_objective.target.x, taskforce.current_objective.target.y, defense_radius*global.grid_cell_width,distance_digits)

		var action_component

		switch(action_type){
		case ACTION_TYPES.move_and_attack:
			action_component = generic_taskforce_score_attack(unit, tile, taskforce,target, action_digits)
			break;
		case ACTION_TYPES.move_and_skill:
			action_component = generic_taskforce_score_mustering_skill(unit, tile, taskforce, action_digits)
			break;
		default:
			action_component = 0.2 * power(10,action_digits)
			break;
	
		}

		var defense_component = generic_taskforce_score_tile_defense(unit, tile, defense_digits)
		final_score += defense_component
		final_score += power(10, defense_digits)*action_component
		final_score += power(10, defense_digits + action_digits)*distance_to_objective_component
		final_score += power(10, defense_digits + action_digits+distance_digits)*objective_component
		if global.debug_ai_defender_taskforces_scoring {
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

function defender_taskforce_score_objective_advancing(action_type, unit, tile, taskforce, target){
	var default_score = 2
	var gt = taskforce.current_objective.target
	var tile_is_objective = tile_contains_garrison_target(tile, taskforce, unit.controlling_player, gt)
	var tile_in_objective_zone = point_distance(tile._x, tile._y, gt.x, gt.y) <= gt.garrison_objective_tile_radius * global.grid_cell_width
	var tile_contains_capturable_building = false
	var building_on_tile = instance_position(tile._x, tile._y, par_building)
	var tile_contains_building = building_on_tile != noone
	if building_on_tile != noone {
		if building_on_tile.controlling_player == noone or building_on_tile.controlling_player.id != unit.controlling_player.id {
			tile_contains_capturable_building = true
		}
	}
	
	if tile_is_objective{
		return 8
	}

	if tile_in_objective_zone 
	{
		if tile_contains_building {
			return 7
		}else
		{
			if action_type == ACTION_TYPES.move_and_attack 
			{
				var target_is_on_objective = tile_contains_garrison_target(target,taskforce, unit.controlling_player, gt)
				var target_in_objective_zone = point_distance(target._x, target._y, gt.x, gt.y) <= gt.garrison_objective_tile_radius * global.grid_cell_width

				if target_is_on_objective
				{
					return 7
				}

				if target_in_objective_zone
				{
					return 6
				}
				else
				{
					return 4
				}
			}else
			{
				return 3
			}
		}	
	}else{
		if tile_contains_capturable_building {
			return 4
		}else{
			return 2
		}
	}
	return default_score
}

function tile_contains_garrison_target(tile, taskforce, player, garrison_target){
	var structure_on_tile = instance_position(tile._x, tile._y, par_building)
	if structure_on_tile != noone {
		if ds_list_find_index(garrison_target.list_nearby_structures, structure_on_tile) != -1 
		{
			return true
		}else{
			return false
		}
	}else{
		return false
	}
}
#endregion