function init_globals(){
	//global defaults
	global.default_map = rm_sandbox;

	#region grid and pathing
	// Grid globals and default values
	global.grid_left_startpos = 0;
	global.grid_top_startpos = 0;
	global.grid_nr_h_cells = 20;
	global.grid_nr_v_cells = 20;
	global.grid_cell_width = 64;
	global.grid_cell_height = 64;

	//Pathing globals
	global.path_allow_diag  = 0;
	global.path_move_speed = 3;


	//Debug globals
	global.debug_draw_grid = false;
	#endregion
	
	#region player permissions
		//camera control
		global.camera_controllable = true;
		
		global.player_permission_selection = true;
		global.player_permission_execute_orders = true;
		
	#endregion

	//Querty Azerty stuff
	global.azerty = true;
	global.up = global.azerty?"Z":"W";
	global.left = global.azerty?"Q":"A";
	global.down = "S";
	global.right = "D";



	//animation globals
	global.unit_fade_step = 1/(room_speed);
	global.ai_combat_startup_delay_seconds = 0.5
	global.ai_combat_end_sequence_delay_seconds = 0.5

	//Control
	global.map_running = false;
	
	#region menu globals
	create_colour_picker_options()
	create_player_type_picker_options()
	create_map_picker_options()
	#endregion
	
	#region debug
	global.debug_gui = false;
	#endregion
}

function set_up_camera_controls(){
	global.up = global.azerty?"Z":"W";
	global.left = global.azerty?"Q":"A";
	global.down = "S";
	global.right = "D";
}

function toggle_azerty_qwerty(){
	global.azerty = !global.azerty
	set_up_camera_controls()
}


function create_colour_picker_options(){
	var type = DD_PICKER_TYPES.colour_picker
	var size = 32
	global.all_colour_options = [
	 {col: c_soft_blue, w: size, h: size,dd_type: type },
	 {col: c_soft_green, w: size, h: size,dd_type: type},
	 {col: c_soft_red, w: size, h: size,dd_type: type},
	 {col: c_soft_yellow, w: size, h: size,dd_type: type}
	];
}
function create_player_type_picker_options(){
	var type = DD_PICKER_TYPES.player_type_picker
	global.all_player_type_options = [
		{text: "Human", template: obj_player_human,dd_type: type},
		{text: "Dummy AI", template: obj_player_ai,dd_type: type}
	]
}

function create_map_picker_options(){
	var type = DD_PICKER_TYPES.map_picker
	global.all_map_options = [
		{text: "Sandbox", rm: rm_sandbox,dd_type: type},
	]

}