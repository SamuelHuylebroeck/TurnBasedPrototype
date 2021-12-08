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
		
		//set game to running
		global.game_in_progress = true
		global.map_running = true;
		
	
	
	}	
	

}

function create_player_objects(game_control){
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