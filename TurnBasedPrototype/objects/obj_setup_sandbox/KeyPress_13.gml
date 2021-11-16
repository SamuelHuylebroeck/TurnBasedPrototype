/// @description ??
with(obj_control){
	ds_list_add(ds_turn_order, other.player_one)
	ds_list_add(ds_turn_order, other.player_two)
	ds_list_add(ds_turn_order, other.player_three)
	
	global.game_in_progress = true
	global.map_running = true;
}

instance_destroy()