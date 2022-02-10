
#region setup ingame pause pages
function init_options_pages()
{
	var config_map = load_config_from_file()
	
	var ds_menu_settings = create_menu_page([
		["Audio",		menu_element_types.page_transfer,  options_menu_page.audio],
		["Video",		menu_element_types.page_transfer,  options_menu_page.video],
		//["Controls",	menu_element_types.page_transfer,  options_menu_page.controls],
		["Game",		menu_element_types.page_transfer,  options_menu_page.game],
	
	])
	var audio_map = ds_map_find_value(config_map, "audio")
	var ds_menu_audio = create_menu_page([
		["Master",	menu_element_types.slider,			change_master_volume, clamp(ds_map_find_value(audio_map, "master"),0,1), [0,1]],
		["Sfx",		menu_element_types.slider,			change_sfx_volume, clamp(ds_map_find_value(audio_map, "sfx"),0,1), [0,1]],
		["Music",	menu_element_types.slider,			change_music_volume, clamp(ds_map_find_value(audio_map, "music"),0,1) , [0,1]],
		["Back",	menu_element_types.page_transfer,	options_menu_page.settings],
	])
	#region apply loaded audio settings
	change_master_volume(ds_menu_audio[# 3,0], false)
	change_sfx_volume(ds_menu_audio[# 3,1], false)
	change_music_volume(ds_menu_audio[# 3, 2], false)
	#endregion
	
	var video_map = ds_map_find_value(config_map, "video") 
	var ds_menu_video = create_menu_page([
		["Resolution",	menu_element_types.shift,	change_resolution,	ds_map_find_value(video_map, "resolution"), ["3840 x 2160","1920 x 1080" ,"1600 x 900","1536 x 864","1440 x 900","1366 x 768", "1024 x 768"]],
		["Fullscreen",	menu_element_types.toggle,	change_window_mode, ds_map_find_value(video_map, "fullscreen"),		["Windowed", "Fullscreen"]],
		["UI Scale",	menu_element_types.shift,	change_ui_scale,	ds_map_find_value(video_map, "ui_scale"),		["Small", "Medium", "Large"]],
		["Back",		menu_element_types.page_transfer,  options_menu_page.settings],
	])
	#region apply loaded video settings
	change_resolution(ds_menu_video[# 3,0])
	change_window_mode(ds_menu_video[# 3,1])
	change_ui_scale(ds_menu_video[# 3, 2])
	#endregion
	
	var ds_menu_controls = create_menu_page([
		["Camera up",		menu_element_types.input,	"up" ,					"z"],
		["Camera down",		menu_element_types.input,	"down" ,				"s"],
		["Camera left",		menu_element_types.input,	"left" ,				"q"],
		["Camera right",	menu_element_types.input,	"right" ,				"d"],
		["Show healtbars",	menu_element_types.input,	"show_healthbars" ,		"vk_left_shift"],
		["End Turn",		menu_element_types.input,	"hotkey_end_turn" ,		"vk_enter"],
		["Mark done",		menu_element_types.input,	"hotkey_mark_done" ,	"vk_space"],
		["Back",			menu_element_types.page_transfer,  options_menu_page.settings],
	])
	
	var game_map = ds_map_find_value(config_map, "game") 
	var ds_menu_game = create_menu_page([
		["Show healthbars",		menu_element_types.shift,	change_show_health_bars, ds_map_find_value(game_map, "show_healthbars"),	["No","Damaged only", "Always"]],
		["Fast Pathing",		menu_element_types.toggle,  change_pathing_speed ,	ds_map_find_value(game_map, "fast_pathing"),	["Normal" ,"Fast" ]],
		["Back",			menu_element_types.page_transfer,  options_menu_page.settings],
	])
	#region apply loaded game settings
	change_show_health_bars(ds_menu_game[# 3,0])
	change_pathing_speed(ds_menu_game[# 3,1])
	#endregion
	
	clean_up_config_map(config_map)
	
	var pages = [ds_menu_settings, ds_menu_audio, ds_menu_video, ds_menu_controls, ds_menu_game]
	return pages
}
#endregion



