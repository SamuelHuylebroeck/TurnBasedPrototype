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
	global.pause_game = vk_escape
	global.key_mark_unit_done = "X"
	global.key_next_available_unit = "C"
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
	
	global.view_width = camera_get_view_width(view_camera[0])
	global.view_height = camera_get_view_height(view_camera[0])
	global.in_game_pause_menu_active  = false
	global.ui_width = display_get_gui_width()
	global.ui_height = display_get_gui_height()
	display_set_gui_size(global.ui_width, global.ui_height)
	
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
	//Debug globals
	global.debug_draw_grid = false;
	
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
	
	#region video settings
	define_resolution_settings()
	define_ui_settings()
	#endregion
	
	#region audio settings
	define_audio_settings()
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
	
	var forge_lord = new recruitment_option("Forge Lord", obj_unit_forgelord, 400)
	ds_list_add(global.ds_basic_recruitment_options, forge_lord)
	
	var ground_splitter = new recruitment_option("Groundsplitter", obj_unit_groundsplitter, 370)
	ds_list_add(global.ds_basic_recruitment_options, ground_splitter)
	
	var captain = new recruitment_option("Captain", obj_unit_captain_knight, 350)
	ds_list_add(global.ds_basic_recruitment_options, captain)


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


function define_resolution_settings(){
	global.resolution_options[menu_supported_resolution.res_3840x2160] = [3840, 2160]
	global.resolution_options[menu_supported_resolution.res_1920x1080] = [1920, 1080]
	global.resolution_options[menu_supported_resolution.res_1600x900] = [1600, 900]
	global.resolution_options[menu_supported_resolution.res_1536x864] = [1536, 864]
	global.resolution_options[menu_supported_resolution.res_1440x900] = [1440, 900]
	global.resolution_options[menu_supported_resolution.res_1366x768] = [1366, 768]
	global.resolution_options[menu_supported_resolution.res_1024x768] = [1024, 768]
}

function define_ui_settings()
{
	// [ x_scale, y_scale, font_array]
	global.ui_scale_values[gui_sizes.small] = [1,1,[font_gui_xsmall, font_gui_small, font_gui_medium]]
	global.ui_scale_values[gui_sizes.medium] = [2,2,[font_gui_small, font_gui_medium, font_gui_large]]
	global.ui_scale_values[gui_sizes.large] = [3,3,[font_gui_medium, font_gui_large, font_gui_xlarge]]
	global.current_ui_scale = gui_sizes.medium
	
	global.draw_healthbars = draw_healthbar_condition.damaged_only

}

function define_audio_settings()
{
	audio_group_load(audiogroup_music)
	audio_group_load(audiogroup_sfx)
	audio_group_load(audiogroup_voice)
	
	global.sound_music_scale = 1;
	global.sound_effect_scale = 1;
	global.sound_master_scale = 1;
	
	global.sfx_priority = 1100;
	global.sfx_gain_base = 1;
	
	global.music_base_gain = 1000;
	
	build_master_sound_map()
}