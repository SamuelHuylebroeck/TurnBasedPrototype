/// @description Weather contact effects
/// @description terrain contact effects-
if(current_state != UNIT_STATES.dying){
	var weather = other
	if(not ds_map_exists(ds_weather_crossed, weather.id)){
		//Add terrain to collision set and resolve contact effects
		//show_debug_message("Contact between U("+string(id)+") and W("+string(weather.id)+")")
		resolve_unit_weather_contact(self, weather)
		ds_map_add(ds_weather_crossed, weather.id, weather)
	}
}
