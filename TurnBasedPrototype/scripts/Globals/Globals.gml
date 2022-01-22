function init_globals(){
	//global defaults
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
	
	global.player_permission_click_next_turn = true;
		
	#endregion
	
	define_ai_globals()
	
	#region keybindings
	//Querty Azerty stuff
	global.azerty = true;
	global.up = global.azerty?"Z":"W";
	global.left = global.azerty?"Q":"A";
	global.down = "S";
	global.right = "D";
	#endregion

	#region victory_config
	global.flag_control_fraction = 0.75
	#endregion

	//animation globals
	global.unit_fade_step = 1/(room_speed);

	//Control
	global.map_running = false;
	
	create_recruitment_options()
	
	#region menu globals
	create_colour_picker_options()
	create_player_type_picker_options()
	create_map_picker_options()

	enum menu_locks {
		ps_type,
		ps_colour
	
	}
	global.menu_locks[menu_locks.ps_type] = false
	global.menu_locks[menu_locks.ps_colour] = false
	#endregion
	
	#region weather
	define_weather_relations()
	#endregion
	
	#region debug
	global.debug_gui = false;
	
	global.debug_ai = false;
	
	global.debug_ai_scoring = false;
	global.debug_ai_recruitment = false;
	global.debug_ai_execution = false;
	global.debug_ai_objective_update = false;
	
	global.debug_ai_raider_taskforces = false;
	global.debug_ai_raider_taskforces_scoring = false;
	global.debug_ai_raider_taskforces_execution = false;
	
	global.debug_ai_assault_taskforces = false;
	global.debug_ai_assault_taskforces_scoring = false;
	global.debug_ai_assault_taskforces_execution = false;
	
	global.debug_ai_defender_taskforces = false;
	global.debug_ai_defender_taskforces_scoring = false;
	global.debug_ai_defender_taskforces_execution = false;
	
	global.debug_camera = false
	#endregion
	
	#region combat balance
	define_combat_balance_globals()
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
		{text: "Balanced AI", template: obj_player_ai_balanced,dd_type: type}
	]
}

function create_map_picker_options(){
	var type = DD_PICKER_TYPES.map_picker
	global.all_map_options = [
		{ text: "Four Corners", rm: rm_four_corners_experimental ,
		  dd_type: type, minimap: spr_minimap_four_corners,
		  dim: 25, grid_offset:1, max_players:4},
		{ text: "Forest Showdown", rm: rm_forest_showdown ,
		  dd_type: type, minimap: spr_minimap_forest_showdown,
		  dim: 25, grid_offset:0, max_players:2}
	]

}

function create_recruitment_options(){
	global.ds_basic_recruitment_options = ds_list_create()
	
	var flamesword = new recruitment_option("Flamesword", obj_unit_flamesword, 200)
	ds_list_add(global.ds_basic_recruitment_options, flamesword)

	var windsword = new recruitment_option("Windsword", obj_unit_windsword, 180)
	ds_list_add(global.ds_basic_recruitment_options, windsword)
	
	var waveaxe = new recruitment_option("Wave Axe", obj_unit_waveaxe, 175)
	ds_list_add(global.ds_basic_recruitment_options, waveaxe)
	
	var groundpounder = new recruitment_option("Groundpounder", obj_unit_groundpounder, 220)
	ds_list_add(global.ds_basic_recruitment_options, groundpounder)
	
	var tempest_knight = new recruitment_option("Tempest Knight", obj_unit_tempest_knight, 405)
	ds_list_add(global.ds_basic_recruitment_options, tempest_knight)


}

function define_weather_relations(){
	global.weather_relations[WEATHER_ELEMENTS.fire][WEATHER_ELEMENTS.fire] = WEATHER_RELATIONS.refresh
	global.weather_relations[WEATHER_ELEMENTS.fire][WEATHER_ELEMENTS.water] = WEATHER_RELATIONS.fizzle
	global.weather_relations[WEATHER_ELEMENTS.fire][WEATHER_ELEMENTS.earth] = WEATHER_RELATIONS.detonate
	global.weather_relations[WEATHER_ELEMENTS.fire][WEATHER_ELEMENTS.wind] = WEATHER_RELATIONS.overpower


	global.weather_relations[WEATHER_ELEMENTS.water][WEATHER_ELEMENTS.fire] = WEATHER_RELATIONS.overpower
	global.weather_relations[WEATHER_ELEMENTS.water][WEATHER_ELEMENTS.water] = WEATHER_RELATIONS.refresh
	global.weather_relations[WEATHER_ELEMENTS.water][WEATHER_ELEMENTS.earth] = WEATHER_RELATIONS.fizzle
	global.weather_relations[WEATHER_ELEMENTS.water][WEATHER_ELEMENTS.wind] = WEATHER_RELATIONS.detonate
	
	global.weather_relations[WEATHER_ELEMENTS.earth][WEATHER_ELEMENTS.fire] = WEATHER_RELATIONS.detonate
	global.weather_relations[WEATHER_ELEMENTS.earth][WEATHER_ELEMENTS.water] = WEATHER_RELATIONS.overpower
	global.weather_relations[WEATHER_ELEMENTS.earth][WEATHER_ELEMENTS.earth] = WEATHER_RELATIONS.refresh
	global.weather_relations[WEATHER_ELEMENTS.earth][WEATHER_ELEMENTS.wind] = WEATHER_RELATIONS.fizzle
	
	global.weather_relations[WEATHER_ELEMENTS.wind][WEATHER_ELEMENTS.fire] = WEATHER_RELATIONS.fizzle
	global.weather_relations[WEATHER_ELEMENTS.wind][WEATHER_ELEMENTS.water] = WEATHER_RELATIONS.detonate
	global.weather_relations[WEATHER_ELEMENTS.wind][WEATHER_ELEMENTS.earth] = WEATHER_RELATIONS.overpower
	global.weather_relations[WEATHER_ELEMENTS.wind][WEATHER_ELEMENTS.wind] = WEATHER_RELATIONS.refresh

}
	
function define_ai_globals(){
	global.ai_turn_in_progress = false
	global.ai_turn_completed = false
	
	#region Taskforce AI configuration
	global.taskforce_ai_garrison_grouping_tile_distance = 2
	global.taskforce_ai_raid_opportunity_grouping_tile_distance = 3
	#endregion

}
	
function define_combat_balance_globals(){
	global.max_tile_armour = 20
	global.max_tile_avoid = 50
	global.max_avoid = 150
	global.max_armour = 50
	global.explosion_damage_fraction = 0.2
}