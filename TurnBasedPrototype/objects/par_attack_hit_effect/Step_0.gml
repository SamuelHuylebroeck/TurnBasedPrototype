/// @description ??
if not done and image_speed >0 {	
	if (not effect_applied and floor(image_index)>= hit_frame){
		//Apply effect
		show_debug_message("Apply attack effect here")
		var defender = instance_position(x,y, par_abstract_unit)
		if (defender != noone){
			resolve_attack_hit_effect(linked_attack_profile, linked_attacker, defender)
		}
		effect_applied = true
	}
	
	
	
	if (image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		
		place_weather(x,y,linked_attack_profile.weather_profile)
		//Make invisibile
		visible=false
		image_speed=0
		done = true
	}
}