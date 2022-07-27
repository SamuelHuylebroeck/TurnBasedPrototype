function goto_settings_page(pause_menu, target_page)
{

	with(pause_menu) 
	{
		destroy_pause_page_visualization()
		current_menu_page_index = target_page
		create_pause_page_visualization(pages[current_menu_page_index])
	
	}
}


function exit_to_main_menu()
{
	show_message("Exiting back to main menu is non-functional atm, session does not clean itself properly enough to start a new one")
	room_goto(rm_title)
}

function exit_game()
{
	game_end()
}

function change_master_volume(new_value, play_sound=true)
{
	var new_volume = clamp(new_value, 0,1)
	if(play_sound and not audio_is_playing(snd_master_test)) audio_play_sound(snd_master_test, 1, false)
	audio_master_gain(new_volume)
}

function change_music_volume(new_value, play_sound=true)
{
	var new_volume = clamp(new_value, 0,1)
	if(play_sound and not audio_is_playing(snd_music_test)) audio_play_sound(snd_music_test, 1, false)
	audio_group_set_gain(audiogroup_music,new_volume,0)
}

function change_sfx_volume(new_value, play_sound=true){
	var new_volume = clamp(new_value, 0,1)
	if(play_sound and not audio_is_playing(snd_sfx_test)) audio_play_sound(snd_sfx_test, 1, false)
	audio_group_set_gain(audiogroup_sfx,new_volume,0)

}


function change_resolution(resolution_index){
	//show_debug_message("Changing resolution to " + resolution_string +" through index " + string(resolution_index))
	
	var window_width = global.resolution_options[resolution_index][0]
	var window_heigth = global.resolution_options[resolution_index][1]
	//Update window size
	window_set_size(window_width, window_heigth)
	//Update viewport and surface to match
	view_wport[0] = window_width
	view_hport[0] = window_heigth
	surface_resize(application_surface, window_width, window_heigth)
	
	//Rescale camera
	with(obj_camera){
		camera_width  = (window_width  / window_heigth) * camera_height 
		camera_set_view_size(camera,camera_width,camera_height);
		camera_set_view_border(camera,camera_width,camera_height);
	
	}
	
	//Reset UI globals
	global.ui_width = display_get_gui_width()
	global.ui_height = display_get_gui_height()
}

function change_window_mode(index){
	//show_debug_message("Changing fullscreen to " + index_value +" through index " + string(index))
	switch(index)
	{
		case 1: window_set_fullscreen(true); break;
		case 0: window_set_fullscreen(false); break;
	}

}

function change_ui_scale(ui_scale_index){
	global.current_ui_scale = ui_scale_index
}

function change_show_health_bars(new_show_healthbar_state){
	global.draw_healthbars = new_show_healthbar_state
}

function change_pathing_speed(new_pathing_speed_index){
	switch(new_pathing_speed_index)
	{
		case 1: global.path_move_speed = 6; break;
		default: global.path_move_speed = 3; break;
	}
}
