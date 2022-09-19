#region creation

function create_raider_taskforce(pos_x, pos_y, taskforce_player){
	//Get the closest owned recruitment building
	var tile_center = get_center_of_tile_for_pixel_position(pos_x, pos_y)
	var tf = instance_create_layer(tile_center[0], tile_center[1],"Taskforces", obj_raider_taskforce)
	var closest_recruitment_building = get_closest_controlled_recruitment_building(tile_center[0], tile_center[1], taskforce_player)
	if closest_recruitment_building = noone 
	{
		closest_recruitment_building = taskforce_player
	}
	with(tf){
		self.home_x = closest_recruitment_building.x
		self.home_y = closest_recruitment_building.y
		self.taskforce_player = taskforce_player
	}
	with(taskforce_player){
		ds_list_add(ds_list_taskforces, tf)
	}
	
	if global.debug_ai_raider_taskforces
	{
		show_debug_message("Created Raider taskforce: " + string(tf.id))
	}
}

function update_raider_taskforce_numbers(taskforce_player, current_count, max_count)
{
	var current_round = 0
	with(obj_control){
		current_round = self.current_round
	}
	var allowed_raider_taskforces = min(floor(current_round / taskforce_player.raider_cooldown)+1, max_count)
	var nr_to_create = allowed_raider_taskforces - current_count
	if nr_to_create >0 
	{
		repeat(nr_to_create)
		{
			create_raider_taskforce(taskforce_player.x, taskforce_player.y,taskforce_player)
		}
		ds_map_replace(taskforce_player.ds_map_force_current_composition, obj_raider_taskforce, current_count+nr_to_create)
	}
}
#endregion
#region recruitment
function get_raider_taskforce_recruitment_request(ds_request_queue, taskforce, taskforce_player){
	var i=0
	repeat(2) 
	{
		i++
		if ds_list_size(taskforce.ds_list_taskforce_units)+i <= taskforce.taskforce_max_size{
			var windsword_odds = 0.7
			var flip = random(1)
			var name= "Flamesword"
			var unit_template = obj_unit_marinearcher
			if flip < windsword_odds{
				name = "Windsword"
				unit_template = obj_unit_windsword
			}
			var raider_request = {
				verbose_name: name,
				template: unit_template,
				tf: taskforce
			}
			ds_queue_enqueue(ds_request_queue, raider_request)
		}
	}
}
#endregion
#region management
function update_objectives_all_raider_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Updating Raider taskforces")
	//Loop over each taskforce
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_taskforce_position(tf, ai_player)
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
				//Clear claims on raid opportunities
				if claimed_raid_opportunity != noone 
				{
					ds_map_delete(claimed_raid_opportunity.map_assigned_taskforces, ai_player.id)
				}
				//Get new objectives from opportunities
				var next_opportunity_found = get_new_objectives_from_raid_opportunities(self, ai_player)
				if next_opportunity_found {
					//Apply the an immediate update to get the next current objective
					update_objectives_raider_taskforce(taskforce, ai_player)
				}
				else
				{
					show_debug_message("Raider taskforce did not find an eligible opportunity")
					show_debug_message("Crash likely")
				}
			
			}
		}
	}
}

function get_new_objectives_from_raid_opportunities(taskforce, ai_player)
{
	//Get all opportunities
	var scored_opportunities = ds_priority_create()
	with(obj_raid_opportunity_tracker)
	{
		//Score them based on distance to player and contents
		var ro_score = score_raid_opportunity(self, taskforce)
		ds_priority_add(scored_opportunities, self, ro_score)
	}
	//pop them until a free one is found or when the queue is empty
	var opportunity_found = false
	while(not opportunity_found and not ds_priority_empty(scored_opportunities))
	{
		var next_opportunity = ds_priority_delete_min(scored_opportunities)
		if is_raid_opportunity_available(next_opportunity, ai_player)
		{
			opportunity_found = true
			//Assign the structures of the opportunity to the raider taskforce
			for(var i=0; i<ds_list_size(next_opportunity.list_nearby_structures); i++)
			{
				var new_objective = new Objective(next_opportunity.list_nearby_structures[|i], OBJECTIVE_TYPES.capture)
				ds_queue_enqueue(taskforce.ds_queue_taskforce_objectives, new_objective)
			}
			claimed_raid_opportunity = next_opportunity
			//Assign the raider taskforce to the opportunity
			ds_map_add(next_opportunity.map_assigned_taskforces, ai_player.id, taskforce)
		}
	}
	
	//Cleanup
	ds_priority_destroy(scored_opportunities)
	return opportunity_found
}

function score_raid_opportunity(raid_opportunity,taskforce)
{
	#region explanation
	// Lower score is better
	// XXXX
	// X is the euclidean distance to the player
	#endregion
	var distance_digits = 4
	
	var distance_to_opportunity = point_distance(raid_opportunity.x, raid_opportunity.y, taskforce.x, taskforce.y)
	var max_distance = point_distance(0,0,room_width, room_height)
	var rel_distance_to_opportunity = distance_to_opportunity/max_distance
	
	var compound_score =0
	compound_score += clamp(power(10,distance_digits)*rel_distance_to_opportunity,0,power(10,distance_digits))
	return compound_score
}

function is_raid_opportunity_available(raid_opportunity, ai_player)
{
	//A raid opportunity is available if:
	// 1. at least half of the total buildings are not under control
	// 2. it is not claimed by another taskforce
	var nr_of_structures_under_player_control = 0
	var total_nr_of_structures = ds_list_size(raid_opportunity.list_nearby_structures)
	for(var i=0; i< total_nr_of_structures; i++)
	{
		var structure = raid_opportunity.list_nearby_structures[|i]
		var structure_under_player_control = structure.controlling_player != noone and structure.controlling_player.id == ai_player.id
		if structure_under_player_control
		{
			nr_of_structures_under_player_control++
		}
	}
	
	if nr_of_structures_under_player_control / total_nr_of_structures <=0.5 
	{
		var assigned_taskforce = ds_map_find_value(raid_opportunity.map_assigned_taskforces, ai_player.id)
		if assigned_taskforce = undefined {
			return true 
		}
	}
	return false
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
	////Calculate length of path from tile to objective, ignoring all units
	//mp_grid_clear_all(global.map_grid)
	//add_impassible_tiles_to_grid(unit,false, false)
	//var path_length = get_path_length(global.map_grid,global.navigate, tile._x,tile._y, objective_x, objective_y)
	//var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.grid_cell_width
	
	#region AStar
	//Find path
	var astar_path_result;
	with(global.pathfinder)
	{
		var start_tile = instance_position(tile._x, tile._y, par_pathfinding_tile);
		var destination_tile = instance_position(objective_x,objective_y, par_pathfinding_tile);
		//show_debug_message(string(start_tile)+"->"+string(destination_tile));
		astar_path_result = get_astar_path(start_tile, destination_tile, unit.unit_profile.movement_type)
	}
	
	if(not astar_path_result.path_found)
	{
		return 0;
	}
	
	var path_length = astar_path_result.cost
	var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.taskforce_ai_pathfinding_max_tile_cost

	#endregion
	
	
	var rel_objective_distance_score = (max_distance-(path_length))/max_distance 
	rel_objective_distance_score = clamp(floor(rel_objective_distance_score* power(10,nr_digits)),0,power(10,nr_digits)-1) 
	
	return rel_objective_distance_score
}

function raider_taskforce_score_attack(unit,tile, taskforce,target, nr_digits){
	var maximum_damage = get_attack_damage_ceiling(unit, tile, target,unit.attack_profile)
	var expected_damage = get_attack_expected_damage(unit, tile, target,unit.attack_profile,-0.9)
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


