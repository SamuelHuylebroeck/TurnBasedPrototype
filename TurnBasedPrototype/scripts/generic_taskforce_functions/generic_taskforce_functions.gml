//@description ??
function dummy_taskforce_action_scoring_function(action_type, unit, tile, taskforce){
	return 100
}
#region recruitment
function get_taskforce_recruitment_request_placeholder(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		var placeholder_request = {
			template: obj_unit_flamesword,
			tf: taskforce
			}
		ds_queue_enqueue(ds_request_queue, placeholder_request)
	}
}
#endregion
#region management
function is_objective_completed(objective, taskforce, ai_player){
	if objective == noone{
		return true
	}	
	switch (objective.objective_type){
		case OBJECTIVE_TYPES.capture:
			return is_capture_objective_completed(objective, taskforce, ai_player)
		case OBJECTIVE_TYPES.guard:
			return is_guard_objective_completed(objective, taskforce, ai_player)
	}
}

function is_capture_objective_completed(objective, taskforce, ai_player){
	return (objective.target.controlling_player!=noone) and (objective.target.controlling_player.id == ai_player.id)
}

function is_guard_objective_completed(objective, taskforce, ai_player){
	var gt = objective.target
	for(var i =0; i<ds_list_size(gt.list_nearby_structures); i++){
		var structure = gt.list_nearby_structures[|i]
		if structure.controlling_player != noone and structure.controlling_player.id == ai_player.id
		{
			return false
		}
	
	}
	return true
}

function update_taskforce_position(tf, ai_player)
{
	var nr_units = ds_list_size(tf.ds_list_taskforce_units)	
	if nr_units >0
	{
		//Move to the center of mass
		var _x =0
		var _y =0
		
		for(var i=0; i< nr_units; i++)
		{
			var next_unit = tf.ds_list_taskforce_units[|i]
			if not instance_exists(next_unit)
			{
				show_debug_message(string(next_unit) + " does not exist but is still in the unit list for taskforce " + string(tf))
			}
			_x+=next_unit.x
			_y+=next_unit.y
				
		}
		
		_x = _x/nr_units
		_y = _y/nr_units
		
		var new_center = get_center_of_tile_for_pixel_position(_x, _y)
		tf.x= new_center[0]
		tf.y=new_center[1]
		
	}else
	{
		//Move to player position
		tf.x = ai_player.x
		tf.y = ai_player.y
	}
}
#endregion
#region scoring
function generic_taskforce_score_retreating(action_type, unit, tile,taskforce,target){
	#region Score explanation
	//ABBBBCCDD
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
		action_component = generic_taskforce_score_attack(unit, tile, taskforce,target, action_digits)
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
	if global.debug_ai_scoring {
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
	//mp_grid_clear_all(global.map_grid)
	//add_impassible_tiles_to_grid(unit,false, false)
	//var path_length = get_path_length(global.map_grid,global.navigate, tile._x,tile._y, zone_center_x, zone_center_y)
	//var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.grid_cell_width
	
	#region AStar
	//Find path
	var astar_path_result;
	with(global.pathfinder)
	{
		var start_tile = instance_position(tile._x, tile._y, par_pathfinding_tile);
		var destination_tile = instance_position(zone_center_x,zone_center_y, par_pathfinding_tile);
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

function generic_taskforce_score_attack(unit, tile, taskforce,target, nr_digits){
	var maximum_damage = get_attack_damage_ceiling(unit, tile, target,unit.attack_profile)
	var expected_damage = get_attack_expected_damage(unit, tile, target,unit.attack_profile,-1.1)
	var rel_expected_damage = expected_damage/maximum_damage

	if (global.debug_ai_scoring) show_debug_message(string(expected_damage)+"/"+string(maximum_damage)+":"+string(rel_expected_damage))
	
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
	if (global.debug_ai_scoring) show_debug_message(string(sum_preferred_targets) + "," + string(skill_score)+"/"+string(max_skill_score)+":"+string(rel_skill_score))
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
	//ABBBBCCDEE
	//A is 4 if the action does not take place inside the home area
	//6 for attack and skill moves if the tile is in the home area
	//6 for moves if the tile  in the inner home area (r/2)
	//5 for moves in the outer home area (r)
	//BBB is the remaining path distance towards the home area center, from the target tile, ignoring all units
	//The distance score is maxed when the target tile is in the home zone

	//CC is the action score on the tile, with 20 being no action. 
	//Skill can take priority over attack if enough more targets are effected
	//D is a penalty score for the tiles surrounding the recruitment building
	// 5 for a tile not next to the recruitment building, 4 for a tile directly next to it
	//EE is the defensive score of the tile, with the current tile getting a slight bump
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
	var recruitment_space_penalty=5
	var distance_to_home = point_distance(tile._x, tile._y, taskforce.home_x, taskforce.home_y)
	if distance_to_home <= global.grid_cell_width and distance_to_home != 0 
	{
		recruitment_space_penalty = 4
	}
	
	final_score = defense_component
	final_score += recruitment_space_penalty+power(10,defense_digits)
	final_score += power(10, defense_digits+1)*action_component
	final_score += power(10,defense_digits+1 + action_digits)*distance_to_objective_component
	final_score += power(10,defense_digits+1 + action_digits+distance_digits)*objective_component
	if global.debug_ai_scoring {
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

function generic_taskforce_score_mustering_skill(unit, tile, taskforce, nr_digits){
	#region scoring explanation
	//A weather effect can have either friendly(boon) or enemy prefered targets
	//Each preferred target counts as a half a full power attack
	//Each non-preferred target substracks half a full power attack in score
	//Only apply score for tiles that have the skill effect terrain linger, refresh or detonate
	#endregion
	var sum_preferred_targets =  get_sum_preferred_targets(unit,tile,unit.weather_profile)
	var skill_score = sum_preferred_targets*1/2*unit.attack_profile.base_damage
	var max_skill_score = get_attack_damage_ceiling(unit,tile,tile,unit.attack_profile)
	var rel_skill_score = clamp(skill_score/max_skill_score,-1,1)/2+0.5
	if (global.debug_ai_scoring) show_debug_message(string(sum_preferred_targets) + "," + string(skill_score)+"/"+string(max_skill_score)+":"+string(rel_skill_score))
	if rel_skill_score == 0.5 
	{
		//With neutral targets, do not do the skill
		rel_skill_score = 0
	}
	rel_skill_score = clamp(floor(rel_skill_score),0,power(10,nr_digits)-1) 
	return rel_skill_score
}


function generic_taskforce_score_tile_defense(unit, tile, nr_digits)
{
	#region explanation
	//Defensive score is based on the average between the final defensive stats of the tile
	//And the relative HP change for entering and starting on the tile
	//If standing on the tile would kill the unit, the score is zeroed out
	#endregion
	//Check which defense type is dominant for the unit and get scales
	var avoid_contribution, armour_contribution
	var stats_score = 0
	var hp_change = 0
	var rel_armour = 0
	var rel_avoid = 0
	if(is_armour_dominant_defense(unit))
	{
		avoid_contribution = 0.3
		armour_contribution = 0.7
	}else{
		avoid_contribution = 0.7
		armour_contribution = 0.3
	}
	//Get individual contributions from terrain
	var terrain_on_tile = instance_position(tile._x, tile._y, par_terrain)
	if terrain_on_tile != noone 
	{
		var total_armour = terrain_on_tile.armour_modifier
		rel_armour  = armour_contribution * clamp(total_armour/global.max_tile_armour,-1,1)
		
		var total_avoid = terrain_on_tile.avoid_modifier
		rel_avoid  = avoid_contribution * clamp(total_avoid/global.max_tile_avoid,-1,1)
		
		if terrain_on_tile.contact_hp_change != 0 
		{
			hp_change += terrain_on_tile.contact_hp_change
		}
		if terrain_on_tile.start_of_turn_hp_change != 0 
		{
			hp_change += terrain_on_tile.start_of_turn_hp_change * unit.unit_profile.max_hp
		}
	}
	
	//Get weather on tile
	var weather_on_tile = instance_position(tile._x, tile._y, par_weather)
	if weather_on_tile != noone 
	{
		if weather_on_tile.weather_scoring_hp_change_per_turn != 0
		{
			hp_change += weather_on_tile.weather_scoring_hp_change_per_turn*weather_on_tile.weather_boon_bane_duration		
		}
	}
	
	stats_score = clamp(rel_armour + rel_avoid,-1,1)
	stats_score = stats_score/2+0.5
	
	var hp_score = min(unit.current_hp+hp_change, unit.unit_profile.max_hp)/unit.unit_profile.max_hp
	var rel_defensive_score = (stats_score+hp_score)/2
	if hp_score <= 0 {
		rel_defensive_score = 0
	}
	
	//Rescale from [0,1] to [0,10^digits[
	rel_defensive_score = clamp(floor(rel_defensive_score*power(10,nr_digits)),0,power(10,nr_digits)-1) 
	return rel_defensive_score
}
#endregion