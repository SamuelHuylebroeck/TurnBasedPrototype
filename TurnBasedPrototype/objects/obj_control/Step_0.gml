/// @description ??
if(global.map_running)
{
	//Get the player
	var active_player = get_current_active_player()
	if (active_player.object_index == obj_player_human){
		take_player_turn()
	}else if (active_player.object_index == obj_player_ai) {
		//Do nothing for now
		show_debug_message("Taking AI turn")
		take_dummy_ai_turn()
	}
	
}