function init_globals(){
	//global defaults
	global.default_map = rm_sandbox;

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


	//Querty Azerty stuff
	global.azerty = true;
	global.up = global.azerty?"Z":"W";
	global.left = global.azerty?"Q":"A";
	global.down = "S";
	global.right = "D";

	//camera control
	global.camera_controllable = true;

	//animation globals
	global.unit_fade_step = 1/(room_speed);
	global.ai_combat_startup_delay_seconds = 0.5
	global.ai_combat_end_sequence_delay_seconds = 0.5

	//Control
	global.map_running = false;
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