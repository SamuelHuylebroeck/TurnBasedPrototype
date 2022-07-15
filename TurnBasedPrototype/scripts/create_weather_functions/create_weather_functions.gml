#region init functions

function draw_create_weather_preview(origin_unit, weather_profile){
	var targets = get_burst_target_positions(origin_unit.x,origin_unit.y,weather_profile.weather_burst_size)
	for(var i=0; i< ds_list_size(targets);i++){
		var target_pos = targets[| i]
		instance_create_layer(target_pos._x, target_pos._y, "UI", obj_create_weather_preview)
	}
}



function clean_up_create_weather_preview(){
	with(obj_create_weather_preview){
		instance_destroy()
	}

}

function draw_create_weather(_x, _y, linked_unit, weather_profile){
	var cwi = instance_create_layer(_x, _y, "UI",obj_placeholder_create_weather_command)
	with(cwi){
		self.linked_weather_profile = weather_profile
		self.linked_unit = linked_unit
	}

}
	
	
function start_create_weather(origin_unit, weather_profile){
	//Turn off player control
	global.player_permission_execute_orders = false
	//Clean up pathing information
	clean_possible_moves()
	//Setup the animation for the attacking unit
	with(origin_unit){
		image_index = 0
		sprite_index = animation_sprites[UNIT_STATES.attacking]
		current_state = UNIT_STATES.attacking
	}
	//Create the hit effect tiles
	create_weather_effect_objects(ds_weather_effect_objects, weather_profile);
	
	//sfx
	play_sound(weather_profile.weather_sfx)
}


#endregion

#region animation control
function create_weather_effect_objects(ds_weather_effect_objects, weather_profile){

	var targets = get_burst_target_positions(x,y, weather_profile.weather_burst_size);
	for(var i=0; i< ds_list_size(targets);i++){
		var target_pos = targets[| i]
		create_weather_effect_object_at_location(target_pos._x, target_pos._y,  weather_profile);
		
	}
} 

function create_weather_effect_object_at_location(_x, _y, weather_profile){
	var instance = instance_create_layer(_x, _y, "Weather", obj_placeholder_create_weather_effect)
	with(instance){
		//Calculate when the attack should trigger
		var time_to_create_frame =   1 * game_get_speed(gamespeed_fps) //TODO create animation profile for weather create action
		alarm[0] = time_to_create_frame
		// Set the required data
		linked_weather_profile = weather_profile
	}
}
#endregion