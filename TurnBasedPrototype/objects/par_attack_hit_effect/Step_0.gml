/// @description ??
if not done and image_speed >0 {	
	if (not effect_applied and floor(image_index) == hit_frame){
		//Apply effect
		show_debug_message("Apply attack effect here")
		effect_applied = true
	}
	
	
	
	if (image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		//Create weather
		var weather_instance = instance_create_layer(x,y,"Weather", linked_attack_profile.weather_profile.weather_type)
		with(weather_instance){
			initial_duration = other.linked_attack_profile.weather_profile.weather_duration
			current_duration = initial_duration
		}
		//Make invisibile
		visible=false
		image_speed=0
		done = true
	}
}