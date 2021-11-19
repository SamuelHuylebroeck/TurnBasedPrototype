//@description ??
function execute_fading_state(){
	if (image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		instance_destroy()
	}
}

function execute_present_state(){
	
	//Do nothing
}

function fade_weather(){
	sprite_index = fading_sprite
	image_index = 0
	current_state= WEATHER_STATES.fading

}