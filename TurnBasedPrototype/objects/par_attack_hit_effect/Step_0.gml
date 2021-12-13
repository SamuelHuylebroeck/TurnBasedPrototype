/// @description ??
if not done and image_speed >0 {	
	if (not effect_applied and floor(image_index) == hit_frame){
		//Apply effect
		show_debug_message("Apply attack effect here")
		var defender = instance_position(x,y, par_abstract_unit)
		if (defender != noone){
			resolve_attack_hit_effect(linked_attack_profile, linked_attacker, defender)
		}
		effect_applied = true
	}
	
	
	
	if (image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		
		if instance_position(x,y, par_weather) == noone {
			//Create weather
			var weather_instance = instance_create_layer(x,y,"Weather", linked_attack_profile.weather_profile.weather_type)
			with(weather_instance){
			
				// Scale duration to number of players
				var nr_players
				with(obj_control){
					nr_players= ds_list_size(ds_turn_order)
				}
			
				initial_duration = nr_players *other.linked_attack_profile.weather_profile.weather_duration+1
				current_duration = initial_duration
			
			}
		}
		//Make invisibile
		visible=false
		image_speed=0
		done = true
	}
}