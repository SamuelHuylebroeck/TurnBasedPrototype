#region setup customization
function add_new_player(player_setup){
	var current_nr_of_players = ds_list_size(player_setup.ds_active_players)
	with(player_setup){
		var new_player = instance_create_layer(x+frame_inner_margin, y+frame_inner_margin+(current_nr_of_players)*player_config_height, "Buttons", obj_single_player_config)
		with(new_player){
			player_name="Player " + string(current_nr_of_players+1)
			self.player_setup = player_setup
			self.player_remove_button.player_setup = player_setup
			self.player_remove_button.single_player_config = new_player
		}
		ds_list_add(ds_active_players, new_player)
		//Set the add button to the correct position
		add_button.y = y+frame_inner_margin+(current_nr_of_players+1)*player_config_height
		if not can_add_new_player(self){
			add_button.visible = false
		}
	}
	
}


function remove_player(player_setup, single_player_config){
	with(player_setup){
		var i = ds_list_find_index(ds_active_players, single_player_config)
		ds_list_delete(ds_active_players, i)
		var current_nr_of_players = ds_list_size(player_setup.ds_active_players)
		//Reset the player positions
		for(var i= 0; i<ds_list_size(ds_active_players);i++){
			var p = ds_active_players[|i]
			move_single_player_config(p,x+frame_inner_margin,y+frame_inner_margin+(i)*player_config_height) 	
		}
		add_button.y = y+frame_inner_margin+(current_nr_of_players)*player_config_height
		if can_add_new_player(self){
			add_button.visible = true
		}
	}
	with(single_player_config){
		instance_destroy()
	}
}

function can_add_new_player(player_setup){
	var current_nr_of_players = ds_list_size(player_setup.ds_active_players)
	var map_max_players = player_setup.map_setup.map_picker.current_option.max_players
	return current_nr_of_players<absolute_max_players and current_nr_of_players < map_max_players

}
	
function move_single_player_config(spc, _x,_y){
	with(spc){
		x = _x
		y = _y

		player_type_picker.x = _x+col_width+col_inner_margin
		player_type_picker.y = _y
	
		player_colour_picker.x= _x+2*(col_width+col_inner_margin)
		player_colour_picker.y= _y

		player_remove_button.x =_x+3*(col_width+col_inner_margin)
		player_remove_button.y =_y
	}

}
#endregion

#region Room transition

function button_start_game(){
	with(obj_menu_game_setup){
		//Singleton object and manually hooked up in the room editor
		menu_start_game(self)
	}

}


function menu_start_game(menu_game_setup){
	show_debug_message("Starting game")
	// Create game setup object
	var game_setup = instance_create_layer(0,0,"Logic", obj_setup_multiplayer)
	add_all_player_config_info(menu_game_setup, game_setup)
	// Update globals
	var map_config = menu_game_setup.map_setup.map_picker.current_option
	global.grid_nr_h_cells = map_config.dim;
	global.grid_nr_v_cells = map_config.dim;
	global.grid_left_startpos = map_config.grid_offset*global.grid_cell_width;
	global.grid_top_startpos = map_config.grid_offset*global.grid_cell_height;
	// Transition to room
	var target_room = map_config.rm
	room_goto(target_room)
	game_setup.alarm[0]=5
}

#endregion

function add_all_player_config_info(menu_game_setup, game_setup){
	for(var i=0; i<ds_list_size(menu_game_setup.player_setup.ds_active_players);i++){
		var spc = menu_game_setup.player_setup.ds_active_players[|i]
		var spc_info = get_single_player_config_info(spc)
		ds_list_add(game_setup.ds_player_configs, spc_info)
	}

}

function get_single_player_config_info(single_player_config){
	var player_info = {
		player_name: single_player_config.player_name,
		template: single_player_config.player_type_picker.current_option.template,
		player_colour: single_player_config.player_colour_picker.current_option.col
	}
	return player_info

}

