function end_game_flag_victory(player){
	global.map_running = false
	//Create stat screen
	room_goto(rm_title)
	var victory_message = instance_create_layer(0,0,"Logic", obj_victory_message)
	with(victory_message){
		text_contents = "Winner: " +string(player.player_name)
		alarm[0]=1
	}
}