function start_game(setup_multiplayer){
	var game_control
	with(obj_control){
		game_control = self.id
	}
	with(setup_multiplayer){
		//create players
		create_player_objects(game_control)
		
		//Assign spawn locations
		assign_and_populate_starting_spawns(game_control)
		//Configure grid
		destroy_pathfinding_grid()
		recreate_pathfinding_grid()
		
		//Set up victory conditions
		init_victory_conditions(game_control)
		
		//Setup garrison objective tracking
		init_garrison_objective_tracking(game_control)
		init_raid_opportunity_tracking(game_control)
		
		//Create ingame pause menu object
		instance_create_layer(0,0,"UI", obj_pause_menu)
		
		if global.debug_ai
		{
			instance_create_layer(0,0,"Logic", obj_taskforce_debug_controller)
		}
		
		//set game to running
		global.game_in_progress = true
		global.map_running = true;
	}	
	

}

function create_player_objects(game_control){
	//Clean up old players
	with(par_player){
		instance_destroy()
	}
	
	for(var i= 0; i< ds_list_size(ds_player_configs); i++){
		var pc = ds_player_configs[| i]
		var player = create_player(pc)
		ds_list_add(game_control.ds_turn_order, player)
	}
}

function create_player(player_config){
	var player= instance_create_layer(0,0,"Logic", player_config.template)
	with(player){
		player_colour = player_config.player_colour
		player_name = player_config.player_name
	
	}
	return player
}

function assign_and_populate_starting_spawns(game_control){
	
	var ds_open_starting_spawns = ds_list_create()
	populate_all_starting_spawns(ds_open_starting_spawns)
	
	//Assign pairswise
	var nr_of_pairs = floor(ds_list_size(game_control.ds_turn_order)/2)
	var remainder = floor(ds_list_size(game_control.ds_turn_order)%2)
	var ds_player_stack = ds_stack_create()
	
	populate_player_stack(ds_player_stack, game_control.ds_turn_order)
	repeat(nr_of_pairs){
		var player_one = ds_stack_pop(ds_player_stack)
		var player_two = ds_stack_pop(ds_player_stack)
		
		//Pick a random one for the first player
		var random_index = irandom(ds_list_size(ds_open_starting_spawns)-1) //irandom is inclusive
		var player_one_start_spawn = ds_list_find_value(ds_open_starting_spawns, random_index)
		assign_spawn(player_one, player_one_start_spawn)
		//Pick the one 'opposite' to this
		var opposite_spawn_index =pick_opposite_starting_location(player_one_start_spawn,ds_open_starting_spawns)
		var player_two_spawn = ds_list_find_value(ds_open_starting_spawns, opposite_spawn_index)
		assign_spawn(player_two, player_two_spawn)
		//Remove from list
		ds_list_delete(ds_open_starting_spawns, random_index)
		var updated_index = ds_list_find_index(ds_open_starting_spawns, ds_open_starting_spawns)
		ds_list_delete(ds_open_starting_spawns,updated_index)
			
	}
	//Assign the straggler if needed
	if remainder >0 {
		var straggler_player = ds_stack_pop(ds_player_stack)
		var random_index = irandom(ds_list_size(ds_open_starting_spawns)-1) //irandom is inclusive
		var straggler_start_spawn = ds_list_find_value(ds_open_starting_spawns, random_index)
		assign_spawn(straggler_player, straggler_start_spawn)
	}
	//Consume all starting locations
	
	consume_all_spawns()
	//Cleanup data structures
	ds_stack_destroy(ds_player_stack)
	ds_list_destroy(ds_open_starting_spawns)
	
	cleanup_spawns()
}

function populate_all_starting_spawns(ds_starting_spawns){
	with(obj_player_spawn){
		ds_list_add(ds_starting_spawns, self.id)
	}

}
 
function populate_player_stack(ds_player_stack, ds_player_list){
	for(var i= ds_list_size(ds_player_list)-1; i>=0;i--){
		ds_stack_push(ds_player_stack, ds_player_list[|i].id)
	}
}

function pick_opposite_starting_location(chosen_spawn, ds_starting_spawns){
	var max_opposite_score =0
	var picked_index = 0
	for (var i=0; i<ds_list_size(ds_starting_spawns);i++){
		var spawn_b = ds_starting_spawns[|i]
		if(chosen_spawn.id != spawn_b.id){
			var opposition_score = distance_spawn_score(chosen_spawn, spawn_b)
			if opposition_score > max_opposite_score{
				picked_index = i
				max_opposite_score = opposition_score
			}
		}
		
	}
	return picked_index
	
	
}

function distance_spawn_score(spawn_a, spawn_b){
	with(spawn_a){
		return distance_to_point(spawn_b.x, spawn_b.y)
	}
	
}

function assign_spawn(player, spawn){
	with(spawn){
		self.player = player.id
		for (var i=0; i<array_length(linked_spawns);i++){
			var linked_spawn = linked_spawns[i]
			linked_spawn.player = player.id
		}
	}
	player.x = spawn.x
	player.y = spawn.y
}
	
function consume_all_spawns(){
	with(obj_player_spawn){
		consume_spawn()
	}
}

function consume_spawn(){
	//consume linked spawns
	for (var i=0; i<array_length(linked_spawns);i++){
		var linked_spawn = linked_spawns[i]
		consume_linked_spawn(linked_spawn)
	}

}
function consume_linked_spawn(linked_spawn){
	with(linked_spawn){
		switch(object_get_parent(linked_spawn.object_index)){
			case par_player_spawn_unit:
				if player != noone {
					var instance = instance_create_layer(x,y,spawn_layer,spawn_template)
					instance.controlling_player = player
				}
				break;
			default:
				var instance = instance_create_layer(x,y,spawn_layer,spawn_template)
				if player != noone {
					instance.controlling_player = player
				}
				break;
		}
		instance_destroy()
	}
}

function cleanup_spawns(){
	with(obj_player_spawn){
		instance_destroy()
	}
}

function init_victory_conditions(game_control){
	var total_nr_of_flags=0
	//Total up nr of flags
	with(obj_flag){
		total_nr_of_flags++
		if controlling_player != noone {
			controlling_player.player_current_flag_total++
		}
	
	}
	game_control.flags_to_win = ceil(global.flag_control_fraction * total_nr_of_flags)

}

function init_garrison_objective_tracking(game_control)
{
	//Cluster regions together to create the garrision areas
	#region setup
	//Gather all objectives
	var list_candidate_objectives = ds_list_create()
	var grouping_queue = ds_queue_create()
	
	with(obj_flag)
	{
		ds_list_add(list_candidate_objectives, self.id)
		var candidate_grouping = ds_list_create()
		ds_list_add(candidate_grouping, self.id)
		ds_queue_enqueue(grouping_queue, candidate_grouping)
	}
	with(par_recruitment_building)
	{
		ds_list_add(list_candidate_objectives, self.id)
		var candidate_grouping = ds_list_create()
		ds_list_add(candidate_grouping, self.id)
		ds_queue_enqueue(grouping_queue, candidate_grouping)
	}
	#endregion
	#region clustering
	while(not ds_queue_empty(grouping_queue)){

		var next_candidate_grouping = ds_queue_dequeue(grouping_queue)
		if is_grouping_candidate_valid(next_candidate_grouping,list_candidate_objectives){
			//Check if the grouping can be extended
			var extendable = false
			for(var i=0; i<ds_list_size(list_candidate_objectives);i++){
				var obj = list_candidate_objectives[|i]
				if can_extend_grouping(next_candidate_grouping, obj, global.taskforce_ai_garrison_grouping_tile_distance) {
					extendable = true
					var new_candidate_grouping = ds_list_create()
					ds_list_copy(new_candidate_grouping, next_candidate_grouping)
					ds_list_add(new_candidate_grouping, obj.id)
					ds_queue_enqueue(grouping_queue, new_candidate_grouping)
				}
			}
			if not extendable 
			{
				//This is a final grouping, create a tracker for it
				var mass_center = get_center_of_mass(next_candidate_grouping)
				mass_center = get_center_of_tile_for_pixel_position(mass_center._x, mass_center._y)
				var tracker = instance_create_layer(mass_center[0], mass_center[1], "Logic", obj_garrison_objective_tracker)
				with(tracker)
				{
					ds_list_copy(list_nearby_structures, next_candidate_grouping)
					garrison_objective_tile_radius = global.taskforce_ai_garrison_grouping_tile_distance+1
				}
				//Remove the grouping from the list
				for(var i=0; i<ds_list_size(next_candidate_grouping); i++)
				{
					var obj = next_candidate_grouping[|i]
					var pos = ds_list_find_index(list_candidate_objectives, obj)
					ds_list_delete(list_candidate_objectives, pos)
				}
			}else
			{
				//At least one extension was found, but it is possible that this extension becomes invalid due to another pairing
				//Re-add the grouping before extension to give it another shot
				var new_candidate_grouping = ds_list_create()
				ds_list_copy(new_candidate_grouping, next_candidate_grouping)
				ds_queue_enqueue(grouping_queue, new_candidate_grouping)
			} 
		}
		ds_list_destroy(next_candidate_grouping)
	}
	
	
	#endregion
	
	ds_list_destroy(list_candidate_objectives)
	ds_queue_destroy(grouping_queue)
}
function is_grouping_candidate_valid(grouping,list_available_objectives){
	for(var i=0; i<ds_list_size(grouping); i++){
		var obj = grouping[|i]
		if ds_list_find_index(list_available_objectives, obj) == -1 
		{
			return false
		}
	}
	return true
}

function can_extend_grouping(grouping, candidate_objective, tile_distance){
	if ds_list_find_index(grouping, candidate_objective) != -1 {
		return false
	}
	for(var i=0; i<ds_list_size(grouping); i++){
		var obj = grouping[|i]
		var distance_to_obj = point_distance(candidate_objective.x, candidate_objective.y, obj.x, obj.y)
		if distance_to_obj > tile_distance*global.grid_cell_width
		{
			return false
		}
	}
	return true
}

function get_center_of_mass(list_objects){
	var m_x = 0
	var m_y = 0
	var list_size = ds_list_size(list_objects)
	for(var i=0; i<ds_list_size(list_objects);i++){
		m_x += list_objects[|i].x
		m_y += list_objects[|i].y
	}
	
	return {_x: m_x/list_size, _y: m_y/list_size}
}

function init_raid_opportunity_tracking(game_control)
{
	//Cluster regions together to create the garrision areas
	#region setup
	//Gather all objectives
	var list_candidate_objectives = ds_list_create()
	var grouping_queue = ds_queue_create()
	
	with(obj_flag)
	{
		ds_list_add(list_candidate_objectives, self.id)
		var candidate_grouping = ds_list_create()
		ds_list_add(candidate_grouping, self.id)
		ds_queue_enqueue(grouping_queue, candidate_grouping)
	}
	with(par_recruitment_building)
	{
		ds_list_add(list_candidate_objectives, self.id)
		var candidate_grouping = ds_list_create()
		ds_list_add(candidate_grouping, self.id)
		ds_queue_enqueue(grouping_queue, candidate_grouping)
	}
	
	with(par_income_building)
	{
		ds_list_add(list_candidate_objectives, self.id)
		var candidate_grouping = ds_list_create()
		ds_list_add(candidate_grouping, self.id)
		ds_queue_enqueue(grouping_queue, candidate_grouping)
	}
	
	#endregion
	#region clustering
	while(not ds_queue_empty(grouping_queue)){
		var next_candidate_grouping = ds_queue_dequeue(grouping_queue)
		if is_grouping_candidate_valid(next_candidate_grouping,list_candidate_objectives)
		{
			//Check if the grouping can be extended
			var extendable = false
			for(var i=0; i<ds_list_size(list_candidate_objectives);i++){
				var obj = list_candidate_objectives[|i]
				//show_debug_message("Checking " + string(obj.id) + " for grouping " + string(next_candidate_grouping))
				if can_extend_grouping(next_candidate_grouping, obj, global.taskforce_ai_raid_opportunity_grouping_tile_distance) {
					extendable = true
					var new_candidate_grouping = ds_list_create()
					ds_list_copy(new_candidate_grouping, next_candidate_grouping)
					ds_list_add(new_candidate_grouping, obj.id)
					ds_queue_enqueue(grouping_queue, new_candidate_grouping)
				}
			}
			if not extendable 
			{
				//This is a final grouping, create a tracker for it
				var mass_center = get_center_of_mass(next_candidate_grouping)
				mass_center = get_center_of_tile_for_pixel_position(mass_center._x, mass_center._y)
				var tracker = instance_create_layer(mass_center[0], mass_center[1], "Logic", obj_raid_opportunity_tracker)
				with(tracker)
				{
					ds_list_copy(list_nearby_structures, next_candidate_grouping)
				}
				//Remove the grouping from the list
				for(var i=0; i<ds_list_size(next_candidate_grouping); i++)
				{
					var obj = next_candidate_grouping[|i]
					var pos = ds_list_find_index(list_candidate_objectives, obj)
					ds_list_delete(list_candidate_objectives, pos)
				}
				
			}else
			{
				//At least one extension was found, but it is possible that this extension becomes invalid due to another pairing
				//Re-add the grouping before extension
				var new_candidate_grouping = ds_list_create()
				ds_list_copy(new_candidate_grouping, next_candidate_grouping)
				ds_queue_enqueue(grouping_queue, new_candidate_grouping)
			} 
		}
		ds_list_destroy(next_candidate_grouping)
	}
	#endregion
	
	ds_list_destroy(list_candidate_objectives)
	ds_queue_destroy(grouping_queue)
}