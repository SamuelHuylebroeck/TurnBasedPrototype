/// @description ??
with(obj_control){
	ds_list_add(ds_turn_order, other.player_one)
	ds_list_add(ds_turn_order, other.player_two)
	ds_list_add(ds_turn_order, other.player_three)
	ds_list_add(ds_turn_order, other.player_four)
	
	init_victory_conditions(self)
	init_garrison_objective_tracking(self)
	init_raid_opportunity_tracking(self)
	create_astar_pathfinder()
	
	instance_create_layer(0,0,"UI", obj_pause_menu)
	
	global.game_in_progress = true
	global.map_running = true;
}

instance_destroy()