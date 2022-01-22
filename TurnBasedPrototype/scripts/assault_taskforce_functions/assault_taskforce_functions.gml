#region creation
function update_assault_taskforce_numbers(taskforce_player, current_count, max_count)
{
	var current_round = 0
	with(obj_control){
		current_round = self.current_round
	}
	var allowed_assault_taskforces = min(floor(current_round / taskforce_player.raider_cooldown)+1, max_count)
	//Check if we have enought recruitment support for every force beyond the 1st
	var nr_controlled_recruitment_buildings = 0
	with(par_recruitment_building)
	{
		if controlling_player != noone and controlling_player.id == taskforce_player.id
		{
			nr_controlled_recruitment_buildings++
		}
	}

	var rec_capacity = max(floor(nr_controlled_recruitment_buildings / taskforce_player.assault_required_recruit_support),1)
	var nr_to_create = min(allowed_assault_taskforces - current_count, rec_capacity-current_count)
	if global.debug_ai_assault_taskforces show_debug_message("Creating " + string(nr_to_create) + " ATFs")
	if nr_to_create >0 
	{
		repeat(nr_to_create)
		{
			create_assault_taskforce(taskforce_player.x, taskforce_player.y,taskforce_player)
		}
		ds_map_replace(taskforce_player.ds_map_force_current_composition, obj_assault_taskforce, current_count+nr_to_create)
	}
}

function create_assault_taskforce(_x, _y, taskforce_player)
{
	var new_tf = instance_create_layer(_x,_y,"Taskforces", obj_assault_taskforce)
	with(new_tf){
		self.taskforce_player = taskforce_player 
	}
			
	with(taskforce_player){
		ds_list_add(ds_list_taskforces, new_tf)
	}
}
#endregion
#region recruitment
function get_assault_taskforce_recruitment_request(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		repeat(3){
			var choice = choose(obj_unit_groundpounder, obj_unit_waveaxe, obj_unit_flamesword, obj_unit_tempest_knight)
			//var choice = obj_unit_groundpounder
			var placeholder_request = {
				verbose_name:"Assault Req: " + string(choice),
				template: choice,
				tf: taskforce
			}
			ds_queue_enqueue(ds_request_queue, placeholder_request)
		}
	}
}
#endregion
#region management
function update_objectives_all_assault_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Updating Assault taskforces")
	//Gather all contested flags
	var flag_list = get_all_contested_flags_list(ai_player)
	// Remove already claimed flags
	remove_all_claimed_flags(flag_list, ds_list_taskforces)
	// Assign each unclaimed element to a taskforce if possible
	var current_taskforce_index=0
	for(var i=0;i<ds_list_size(flag_list);i++){
		var next_flag_to_assign = flag_list[|i]
		current_taskforce_index = try_assign_flag_to_taskforce(next_flag_to_assign, ds_list_taskforces, current_taskforce_index)
	}
	// Loop over each taskforce and update stance+home area+objective completion
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_taskforce_stance(tf, ai_player)
		update_objectives_assault_taskforce(tf, ai_player)
		update_taskforce_home_area(tf, ai_player)
	}
	ds_list_destroy(flag_list)
}

function get_all_contested_flags_list(player){
	var flag_list = ds_list_create()
	with(obj_flag){
		if controlling_player == noone or controlling_player.id != player.id
		{
			ds_list_add(flag_list, self)
		}
	
	}
	return flag_list
}

function remove_all_claimed_flags(flag_list, taskforce_list)
{
	var to_remove = ds_queue_create()
	for(var i=0;i<ds_list_size(taskforce_list);i++){
		var tf = taskforce_list[|i]
		if tf.current_objective != noone {
			//Check current objective
			var current_objective_flag =tf.current_objective.target
			if ds_list_find_index(flag_list, current_objective_flag) != -1{
				ds_queue_enqueue(to_remove, current_objective_flag)
			}
		}
		//Check objectives in queue
		check_objective_queue_for_claimed_flags(flag_list, to_remove, tf.ds_queue_taskforce_objectives)
	}
	//Remove all claimed flags
	while(not ds_queue_empty(to_remove)){
		var next_to_remove = ds_queue_dequeue(to_remove)
		var rm_pos = ds_list_find_index(flag_list, next_to_remove)
		ds_list_delete(flag_list, rm_pos)
	}
	ds_queue_destroy(to_remove)

}

function check_objective_queue_for_claimed_flags(flag_list, to_remove_queue, objective_queue){
	var oq_copy = ds_queue_create()
	ds_queue_copy(oq_copy, objective_queue)
	while(not ds_queue_empty(oq_copy))
	{
		var next_objective = ds_queue_dequeue(oq_copy)
		var no_flag = instance_position(next_objective.target.x,next_objective.target.y, obj_flag)
		if ds_list_find_index(flag_list, no_flag) != -1{
			ds_queue_enqueue(to_remove_queue, no_flag)
		}
	}
}

function try_assign_flag_to_taskforce(flag, ds_list_taskforces, starting_position){
	var current_position =starting_position
	var tf_list_size = ds_list_size(ds_list_taskforces)
	repeat(tf_list_size){
		var next_candidate_tf = ds_list_taskforces[|current_position]
		current_position = (current_position+1)%tf_list_size
		// Can be assigned if there is space in the queue
		var available_space = next_candidate_tf.objective_queue_max_size - ds_queue_size(next_candidate_tf.ds_queue_taskforce_objectives)
		available_space = next_candidate_tf.current_objective==noone ? available_space : available_space-1
		if available_space > 0 
		{
			//Create new capture objective
			var objective = new Objective(flag.id, OBJECTIVE_TYPES.capture)
			ds_queue_enqueue(next_candidate_tf.ds_queue_taskforce_objectives,objective)
			break;
		}
	}
	return current_position
}
function update_objectives_assault_taskforce(taskforce, ai_player){
	//Check if current objective is completed
	var complete = is_objective_completed(taskforce.current_objective, taskforce, ai_player)
	if (complete){
		with(taskforce){
			//if yes, pop and move on to next
			var next_objective = ds_queue_dequeue(ds_queue_taskforce_objectives)
			if next_objective != undefined{
				current_objective = next_objective
				x = current_objective.target.x
				y = current_objective.target.y
			}else{
				// Check if there's an unclaimed flag
				// Gather all contested flags
				var flag_list = get_all_contested_flags_list(ai_player)
				var all_assault_taskforces = ds_list_create()
				for(var i=0; i< ds_list_size(ai_player.ds_list_taskforces);i++){
					var tf = ai_player.ds_list_taskforces[|i]
					if tf.object_index == obj_assault_taskforce {
						ds_list_add(all_assault_taskforces, tf)
					}
				}
				// Remove already claimed flags
				remove_all_claimed_flags(flag_list, all_assault_taskforces)
				if (ds_list_size(flag_list) >0){
					var first_flag = flag_list[|0]
					current_objective = new Objective(first_flag.id, OBJECTIVE_TYPES.capture)
					x = current_objective.target.x
					y = current_objective.target.y
					
				}else{
					//No unclaimed flags left, take the same objective as another assault taskforce
					for(var i=0; i<ds_list_size(all_assault_taskforces);i++){
						var atf = all_assault_taskforces[|i]
						if atf.id != self.id and atf.current_objective != noone{
							current_objective = atf.current_objective
							x = current_objective.target.x
							y = current_objective.target.y
							break;
						}
					}
				}
				
				ds_list_destroy(flag_list)
				ds_list_destroy(all_assault_taskforces)
			}
			// if empty, wait for the player to distribute new objectives
			if ds_queue_empty(ds_queue_taskforce_objectives)
			{	
				show_debug_message("Assault taskforce " + string(taskforce) + " has no objectives left in queue")
			}
		}
	}
}


#endregion
#region scoring
function assault_taskforce_action_scoring_function(action_type, unit, tile, taskforce, target){
	switch(taskforce.taskforce_stance){
		case TASKFORCE_STANCES.mustering:
			return generic_taskforce_score_mustering(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.retreating:
			return generic_taskforce_score_retreating(action_type, unit, tile,taskforce,target)
		case TASKFORCE_STANCES.advancing:
		default:
			return assault_taskforce_score_advancing(action_type, unit, tile,taskforce,target)
	}
}

function assault_taskforce_score_advancing(action_type, unit, tile, taskforce, target){
		#region Score explanation
		//ABBBBCCDDEE
		//A is the objective score, scoring as follows
		// 8 if the tile is the objective tile
		// 7 if the target of an attack is on the objective tile
		// 6 if the tile contains a building in the objective zone that is capturable
		// 6 if the tile is in the objective zone and the target of the attack is as well
		// 5 if the tile is in the objective zone and the target of an attack is outside
		// 4 if the tile is in the objective zone for a move 
		// 3 if the tile contains a capturable building and is not in the obbjective zone
		// 2 if the tile is not in the objective zone
		//BBBB is the remaining path distance towards the objective, from the target tile, ignoring all units. If the tile is in the objective zone, this score is maxed out
		//CC is the action score on the tile, with 20 being no action. Skill can take prioirity over attack if enough more targets are effected
		//DD is the defensive score of the tile
		//EE is the euclidean distance to center, with a slight boost given for the current tile
		#endregion
		#region digit config
		var distance_digits = 3
		var action_digits = 2
		var defense_digits = 2
		var euclidean_distance_digits = 2
		#endregion
		var final_score = 0
		var objective_component = assault_taskforce_score_objective_advancing(action_type,unit,tile,taskforce, target)
		
		var distance_to_objective_component =generic_taskforce_score_distance_to_zone(unit,tile,taskforce, taskforce.current_objective.target.x, taskforce.current_objective.target.y, taskforce.assault_tile_radius*global.grid_cell_width,distance_digits)

		var action_component

		switch(action_type){
		case ACTION_TYPES.move_and_attack:
			action_component = assault_taskforce_score_attack(unit, tile, taskforce,target, action_digits)
			break;
		case ACTION_TYPES.move_and_skill:
			action_component = assault_taskforce_score_skill(unit, tile, taskforce, action_digits)
			break;
		default:
			action_component = 0.2 * power(10,action_digits)
			break;
	
		}

		var defense_component = generic_taskforce_score_tile_defense(unit, tile, defense_digits)
		var euclidean_distance_component = point_distance(tile._x, tile._y, taskforce.current_objective.target.x,taskforce.current_objective.target.y)
		euclidean_distance_component = clamp(euclidean_distance_component,0, taskforce.assault_tile_radius*global.grid_cell_width)/(taskforce.assault_tile_radius*global.grid_cell_width)
		euclidean_distance_component = 1-euclidean_distance_component
		euclidean_distance_component = clamp(floor(euclidean_distance_component*power(10,euclidean_distance_digits)),0, power(10, euclidean_distance_digits)-1)
		if unit.x ==tile._x and unit.y == tile._y{
			euclidean_distance_component += 1
			clamp(euclidean_distance_component,0, power(10, euclidean_distance_digits)-1)
		}
		final_score = euclidean_distance_component
		final_score += power(10, euclidean_distance_digits)*defense_component 
		final_score += power(10, euclidean_distance_digits+defense_digits)*action_component
		final_score += power(10, euclidean_distance_digits+defense_digits + action_digits)*distance_to_objective_component
		final_score += power(10, euclidean_distance_digits+defense_digits + action_digits+distance_digits)*objective_component
		if global.debug_ai_assault_taskforces_scoring {
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

function assault_taskforce_score_objective_advancing(action_type, unit, tile, taskforce, target){
	var default_score = 3
	var objective_x  = taskforce.current_objective.target.x
	var objective_y =  taskforce.current_objective.target.y
	var tile_is_objective = tile._x == objective_x and tile._y == objective_y
	var tile_in_objective_zone = point_distance(tile._x, tile._y, objective_x, objective_y) <= taskforce.assault_tile_radius * global.grid_cell_width
	var tile_contains_capturable_building = false
	var building_on_tile = instance_position(tile._x, tile._y, par_building)
	if building_on_tile != noone {
		if building_on_tile.controlling_player == noone or building_on_tile.controlling_player.id != unit.controlling_player.id {
			tile_contains_capturable_building = true
		}
	}
	
	if tile_is_objective{
		return 8
	}
	if action_type == ACTION_TYPES.move_and_attack {
		var target_is_on_objective = target._x == objective_x and target._y == objective_y
		var target_in_objective_zone = point_distance(target._x, target._y, objective_x, objective_y) <= taskforce.assault_tile_radius * global.grid_cell_width

		if target_is_on_objective
			return 7
		if tile_in_objective_zone
		{
			if target_in_objective_zone or tile_contains_capturable_building
			{
				return 6
			}
			else
			{
				return 5
			}
		}else
		{
			if tile_contains_capturable_building {
				return 3
			}else{
				return 2
			}
		}
	}
	if tile_in_objective_zone 
	{
		if tile_contains_capturable_building {
			return 6
		}else{
			return 4
		}
	}else{
		if tile_contains_capturable_building {
			return 3
		}else{
			return 2
		}
	}
	return default_score
}

function assault_taskforce_score_attack(unit,tile, taskforce,target, nr_digits){
	var maximum_damage = get_attack_damage_ceiling(unit, tile, target,unit.attack_profile)
	var expected_damage = get_attack_expected_damage(unit, tile, target,unit.attack_profile,-0.9)
	var rel_expected_damage = expected_damage/maximum_damage
	//Put extra importance on clearing out an objective 
	var  target_on_objective = (target._x == taskforce.current_objective.target.x and target._y == taskforce.current_objective.target.y)
	
	if target_on_objective
	{
		rel_expected_damage = 0.9
	} 
	
	if (global.debug_ai_assault_taskforces_scoring) show_debug_message(string(expected_damage)+"/"+string(maximum_damage)+":"+string(rel_expected_damage)+" - CO: " +string(target_on_objective))
	
	
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

function assault_taskforce_score_skill(unit,tile, taskforce, nr_digits){
	#region scoring explanation
	//A weather effect can have either friendly(boon) or enemy prefered targets
	//Each preferred target counts as a third of a full power attack
	//Each non-preferred target substracks a third of a full power attack in score
	//Only apply score for tiles that have the skill effect terrain linger, refresh or detonate
	#endregion
	var sum_preferred_targets =  get_sum_preferred_targets(unit,tile,unit.weather_profile)
	var skill_score = sum_preferred_targets*1/3*unit.attack_profile.base_damage
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