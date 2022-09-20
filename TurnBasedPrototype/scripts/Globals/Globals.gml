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
	global.unit_fade_step = 1/ (game_get_speed(gamespeed_fps));

	//Control
	global.map_running = false;
	define_unit_stat_map()
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
	
	global.debug_ai = true;
	
	global.debug_ai_scoring = true;
	global.debug_ai_recruitment = false;
	global.debug_ai_execution = true;
	global.debug_ai_objective_update = false;
	
	global.debug_ai_raider_taskforces = false;
	global.debug_ai_raider_taskforces_scoring = true;
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
	//global.all_map_options = [
	//	{ text: "Riverland Duel", rm: rm_riverland_duel ,
	//	  dd_type: type, minimap: spr_minimap_riverland_duel,
	//	  dim: 23, grid_offset:0, max_players:2},
	//	{ text: "Four Corners", rm: rm_four_corners_experimental ,
	//	  dd_type: type, minimap: spr_minimap_four_corners,
	//	  dim: 25, grid_offset:1, max_players:4},
	//	{ text: "Forest Showdown", rm: rm_forest_showdown ,
	//	  dd_type: type, minimap: spr_minimap_forest_showdown,
	//	  dim: 25, grid_offset:0, max_players:2}

	//]
	global.all_map_options = [
		{ text: "Riverland Duel", rm: rm_riverland_duel ,
		  dd_type: type, minimap: spr_minimap_riverland_duel,
		  dim: 23, grid_offset:0, max_players:2}
	]

}

function create_recruitment_options(){
	global.ds_basic_recruitment_options = ds_list_create()
	var complete_profile;
	var key;
	
	key= "Flamesword"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var flamesword = new recruitment_option(key, obj_unit_flamesword, 40,complete_profile, spr_unit_flamesword_idle)
	ds_list_add(global.ds_basic_recruitment_options, flamesword)

	key= "Windsword"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var windsword = new recruitment_option(key, obj_unit_windsword, 20, complete_profile, spr_unit_windsword_idle)
	ds_list_add(global.ds_basic_recruitment_options, windsword)
	
	key= "Wave Axe"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var waveaxe = new recruitment_option(key, obj_unit_waveaxe, 40, complete_profile, spr_unit_waveaxe_idle)
	ds_list_add(global.ds_basic_recruitment_options, waveaxe)
	
	key= "Groundpounder"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var groundpounder = new recruitment_option(key, obj_unit_groundpounder, 30, complete_profile, spr_unit_groundpounder_idle)
	ds_list_add(global.ds_basic_recruitment_options, groundpounder)
	
	key= "Tempest Knight"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var tempest_knight = new recruitment_option(key, obj_unit_tempest_knight, 70, complete_profile, spr_unit_tempestknight_idle)
	ds_list_add(global.ds_basic_recruitment_options, tempest_knight)
	
	key= "Forgelord"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var forge_lord = new recruitment_option(key, obj_unit_forgelord, 80, complete_profile, spr_unit_forgelord_idle)
	ds_list_add(global.ds_basic_recruitment_options, forge_lord)
	
	key= "Groundsplitter"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var ground_splitter = new recruitment_option(key, obj_unit_groundsplitter, 60, complete_profile, spr_unit_groundsplitter_idle)
	ds_list_add(global.ds_basic_recruitment_options, ground_splitter)
	
	key= "Captain Knight"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var captain = new recruitment_option(key, obj_unit_captain_knight, 80, complete_profile, spr_unit_captainknight_idle)
	ds_list_add(global.ds_basic_recruitment_options, captain)
	
	key= "Pyro Archer"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var pyro_archer = new recruitment_option(key, obj_unit_pyroarcher, 60, complete_profile, spr_unit_pyroarcher_idle)
	ds_list_add(global.ds_basic_recruitment_options, pyro_archer)
	
	key= "Bolt Thrower"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var bolt_thrower = new recruitment_option(key, obj_unit_boltthrower, 90, complete_profile, spr_unit_boltthrower_idle)
	ds_list_add(global.ds_basic_recruitment_options, bolt_thrower)
	
	key= "Marine Archer"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var marine_archer = new recruitment_option(key, obj_unit_marinearcher, 40, complete_profile, spr_unit_marinearcher_idle)
	ds_list_add(global.ds_basic_recruitment_options, marine_archer)
	
	key= "Shard Slinger"
	complete_profile = ds_map_find_value(global.unit_stat_map, key)
	var shard_slinger = new recruitment_option(key, obj_unit_shardslinger, 30, complete_profile, spr_unit_shardslinger_idle)
	ds_list_add(global.ds_basic_recruitment_options, shard_slinger)
	
	//tabbed
	global.ds_tabbed_recruitment_options_map = ds_map_create()
	var infantry_list = ds_list_create()
	ds_list_add(infantry_list, flamesword, windsword, groundpounder, waveaxe);
	ds_map_add(global.ds_tabbed_recruitment_options_map,"Inf.", infantry_list)
	var heavy_list = ds_list_create()
	ds_list_add(heavy_list, forge_lord, tempest_knight, ground_splitter, captain);
	ds_map_add(global.ds_tabbed_recruitment_options_map,"Hvy.", heavy_list)
	var archer_list = ds_list_create()
	ds_list_add(archer_list, marine_archer,bolt_thrower, shard_slinger, pyro_archer);
	ds_map_add(global.ds_tabbed_recruitment_options_map,"Arc.", archer_list)
	

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
	global.ai_turn_in_progress = false;
	global.ai_turn_completed = false;
	
	#region Taskforce AI configuration
	global.taskforce_ai_garrison_grouping_tile_distance = 2;
	global.taskforce_ai_raid_opportunity_grouping_tile_distance = 3;
	global.taskforce_ai_pathfinding_max_tile_cost = 4;
	#endregion

}
	
function define_combat_balance_globals(){
	global.max_tile_armour = 20;
	global.max_tile_avoid = 50;
	global.max_avoid = 150;
	global.max_armour = 50;
	global.explosion_damage_fraction = 0.2;
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