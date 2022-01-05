//@description ??
function dummy_taskforce_action_scoring_function(action_type, unit, tile, taskforce){
	return 100
}

function get_taskforce_recruitment_request_placeholder(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		var placeholder_request = {
			template: obj_unit_flamesword,
			tf: taskforce
			}
		ds_queue_enqueue(ds_request_queue, placeholder_request)
	}
}
#region scoring
function generic_taskforce_score_retreating(action_type, unit, tile,taskforce,target){
	#region Score explanation
	//ABBBBCC
	//A is 6 if the move target of the tile is in the home area zone of the taskforce, 5 otherwise
	//BBB is the remaining path distance towards the home area center, from the target tile, ignoring all units
	//The distance score is maxed when the target tile is in the home zone
	//CC is the action score on the tile, with 20 being no action. 
	//Skill can take priority over attack if enough more targets are effected
	//and adverse skill takes priority over plain move when no targets are present
	//DD is the defensive score of the tile, with the current tile getting a slight bump
	#endregion
	#region digit config
	var distance_digits = 3
	var action_digits = 2
	var defense_digits = 2
	#endregion
	var final_score = 0
	var objective_component = 5
	var tile_in_home_zone_radius = point_distance(taskforce.home_x, taskforce.home_y, tile._x, tile._y) <= taskforce.taskforce_homezone_tile_radius*global.grid_cell_width
	if tile_in_home_zone_radius {
		objective_component = 6
	}
	var distance_to_objective_component =generic_taskforce_score_distance_to_zone(unit,tile,taskforce, taskforce.home_x, taskforce.home_y, taskforce.taskforce_homezone_tile_radius*global.grid_cell_width,distance_digits)
	var action_component

	switch(action_type){
	case ACTION_TYPES.move_and_attack:
		action_component = generic_taskforce_score_retreating_attack(unit, tile, taskforce,target, action_digits)
		break;
	case ACTION_TYPES.move_and_skill:
		action_component = generic_taskforce_score_retreating_skill(unit, tile, taskforce, action_digits)
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
	if global.debug_ai_generic_taskforces_scoring {
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
	
function generic_taskforce_score_distance_to_zone(unit,tile,taskforce, zone_center_x, zone_center_y, zone_radius,nr_digits){
	//Check if the tile is in the zone
	if point_distance(tile._x, tile._y, zone_center_x,zone_center_y) <= zone_radius{
		return power(10,nr_digits)-1
	}
	
	//Calculate length of path from tile to home zone center, ignoring all units
	mp_grid_clear_all(global.map_grid)
	add_impassible_tiles_to_grid(unit,false, false)
	var path_length = get_path_length(global.map_grid,global.navigate, tile._x,tile._y, zone_center_x, zone_center_y)
	var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.grid_cell_width
	var rel_objective_distance_score = (max_distance-(path_length))/max_distance 
	rel_objective_distance_score = clamp(floor(rel_objective_distance_score* power(10,nr_digits)),0,power(10,nr_digits)-1) 
	
	return rel_objective_distance_score
}

function generic_taskforce_score_retreating_attack(unit, tile, taskforce,target, nr_digits){
	var maximum_damage = get_attack_damage_ceiling(unit, tile, target,unit.attack_profile)
	var expected_damage = get_attack_expected_damage(unit, tile, target,unit.attack_profile,-1.1)
	var rel_expected_damage = expected_damage/maximum_damage

	if (global.debug_ai_generic_taskforces_scoring) show_debug_message(string(expected_damage)+"/"+string(maximum_damage)+":"+string(rel_expected_damage))
	
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

function generic_taskforce_score_retreating_skill(unit, tile, taskforce, nr_digits){
	#region scoring explanation
	//A weather effect can have either friendly(boon) or enemy prefered targets
	//Each preferred target counts as a half a full power attack
	//Each non-preferred target substracks half a full power attack in score
	//Only apply score for tiles that have the skill effect terrain linger, refresh or detonate
	//Favour doing a skill on empty terrain if the skill is adverse
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
		if rel_skill_score == 0 and not unit.weather_profile.benign {
			rel_skill_score = 0.2*power(10,nr_digits)+1
		}else{
			rel_skill_score = 0.2*power(10,nr_digits)-1
		}
		
	}
	rel_skill_score = clamp(floor(rel_skill_score),0,power(10,nr_digits)-1) 
	return rel_skill_score
}

function generic_taskforce_score_mustering(action_type, unit, tile,taskforce,target){
	#region Score explanation
	//ABBBBCC
	//A is 4 if the action does not take place inside the home area
	//6 for attack and skill moves if the tile is in the home area
	//6 for moves if the tile  in the inner home area (r/2)
	//5 for moves in the outer home area (r)
	//BBB is the remaining path distance towards the home area center, from the target tile, ignoring all units
	//The distance score is maxed when the target tile is in the home zone
	//CC is the action score on the tile, with 20 being no action. 
	//Skill can take priority over attack if enough more targets are effected
	//DD is the defensive score of the tile, with the current tile getting a slight bump
	#endregion
	#region digit config
	var distance_digits = 3
	var action_digits = 2
	var defense_digits = 2
	#endregion
	var final_score = 0
	var objective_component = 4
	var tile_in_home_zone_radius = point_distance(taskforce.home_x, taskforce.home_y, tile._x, tile._y) <taskforce.taskforce_homezone_tile_radius*global.grid_cell_width
	if tile_in_home_zone_radius {
		switch(action_type){
			case ACTION_TYPES.move:
				var in_inner_zone = point_distance(taskforce.home_x, taskforce.home_y, tile._x, tile._y) <taskforce.taskforce_homezone_tile_radius*global.grid_cell_width/2
				objective_component = in_inner_zone ? 6:5
			default:
				objective_component=6
				break;
		}
	}
	var distance_to_objective_component =generic_taskforce_score_distance_to_zone(unit,tile,taskforce, taskforce.home_x, taskforce.home_y, taskforce.taskforce_homezone_tile_radius*global.grid_cell_width,distance_digits)
	var action_component

	switch(action_type){
	case ACTION_TYPES.move_and_attack:
		action_component = generic_taskforce_score_retreating_attack(unit, tile, taskforce,target, action_digits)
		break;
	case ACTION_TYPES.move_and_skill:
		action_component = generic_taskforce_score_retreating_skill(unit, tile, taskforce, action_digits)
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
	if global.debug_ai_generic_taskforces_scoring {
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

function generic_taskforce_score_tile_defense(unit, tile, nr_digits){
	//Check which defense type is dominant for the unit and get scales
	var avoid_contribution, armour_contribution
	var rel_defensive_score = 0
	if(is_armour_dominant_defense(unit)){
		avoid_contribution = 0.3
		armour_contribution = 0.7
	}else{
		avoid_contribution = 0.7
		armour_contribution = 0.3
	}
	
	//Get individual contributions
	var terrain_on_tile = instance_position(tile._x, tile._y, par_terrain)
	if terrain_on_tile != noone {
		var total_armour = terrain_on_tile.armour_modifier + unit.unit_profile.base_armour
		var rel_armour  = armour_contribution * clamp(total_armour/global.max_armour,0,1)
		
		var total_avoid = terrain_on_tile.avoid_modifier + unit.unit_profile.base_avoid
		var rel_avoid  = avoid_contribution * clamp(total_avoid/global.max_avoid,0,1)
	
		rel_defensive_score = clamp(rel_armour + rel_avoid,0,1)
	}
	//Rescale from [0,1] to [0,10^digits[
	rel_defensive_score = clamp(floor(rel_defensive_score),0,power(10,nr_digits)-2) 
	if unit.x ==tile._x and unit.y == tile._y{
		rel_defensive_score += 1 
	}
	return rel_defensive_score
}
#endregion