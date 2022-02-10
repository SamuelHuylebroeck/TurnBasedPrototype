//@description ??
function quit_game(){
	game_end();
}

function start_sandbox(){
	room_goto(rm_sandbox)
}

function goto_map_select(){
	show_debug_message("Go to map select")
	camera_set_view_pos(view_camera[0], 1600, 0)
}

function goto_options(){
	show_debug_message("Go to Options")
	camera_set_view_pos(view_camera[0], 0, 900)
	
	//Create or destroy the current page
	with(obj_title_setting_menu)
	{
		active = true
		create_pause_page_visualization(pages[current_menu_page_index])
	}
}
function goto_title_screen()
{
	
	with(obj_title_setting_menu)
	{
		if active
		{
			save_config_to_file(pages[1],pages[2], pages[3], pages[4])
			destroy_pause_page_visualization()
			active = false
			current_menu_page_index = 0
		}
	}
	camera_set_view_pos(view_camera[0], 0, 0)
}

function goto_victory_screen(){
	show_debug_message("Go to map select")
	camera_set_view_pos(view_camera[0], 3200, 0)
}

function apply_settings()
{
	show_debug_message("Apply settings")
	with(obj_title_setting_menu)
	{
		if active
		{
			save_config_to_file(pages[1],pages[2], pages[3], pages[4])
		}
	}
}
