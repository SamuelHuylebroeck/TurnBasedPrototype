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
}
function goto_title_screen(){
	camera_set_view_pos(view_camera[0], 0, 0)
}

function goto_victory_screen(){
	show_debug_message("Go to map select")
	camera_set_view_pos(view_camera[0], 3200, 0)
}