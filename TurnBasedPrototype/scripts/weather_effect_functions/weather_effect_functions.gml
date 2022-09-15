function resolve_weather_start_of_turn(unit, weather)
{
	#region boon and bane
	if(weather.start_of_turn_boon_bane != noone)
	{
		var bb_name = weather.start_of_turn_boon_bane.verbose_name
		if ds_map_exists(unit.ds_boons_and_banes, bb_name )
		{
			// Refresh duration
			var boon_bane = ds_map_find_value(unit.ds_boons_and_banes, bb_name)
			boon_bane.current_duration = boon_bane.duration
		}else
		{
			//Add to map
			var boon_bane_copy = duplicate_boon_bane(weather.start_of_turn_boon_bane)
			ds_map_add(unit.ds_boons_and_banes, boon_bane_copy.verbose_name, boon_bane_copy)
		}
	}
	#endregion
}

function resolve_unit_weather_contact(unit, weather)
{
	//Apply contact boon and banes
	#region boon and bane
	if(weather.contact_boon_bane != noone)
	{
		var bb_name = weather.contact_boon_bane.verbose_name
		if ds_map_exists(unit.ds_boons_and_banes, bb_name )
		{
			// Refresh duration
			var boon_bane = ds_map_find_value(unit.ds_boons_and_banes, bb_name)
			boon_bane.current_duration = boon_bane.duration
		}else
		{
			//Add to map
			var boon_bane_copy = duplicate_boon_bane(weather.contact_boon_bane)
			ds_map_add(unit.ds_boons_and_banes, boon_bane_copy.verbose_name, boon_bane_copy)
		}
	}
	#endregion
	
}


function place_weather(pos_x, pos_y ,weather_profile){
	var existing_weather = instance_position(pos_x,pos_y, par_weather)
		if  existing_weather == noone {
			//Create weather
			create_weather_at_empty_space(pos_x, pos_y, weather_profile)

		}else{
			var weather_relation = global.weather_relations[weather_profile.weather_element][existing_weather.weather_element]
			switch(weather_relation){
				case WEATHER_RELATIONS.overpower:
					with(existing_weather){
						fade_weather()
					}
					create_weather_at_empty_space(pos_x, pos_y, weather_profile)
					break;
				case WEATHER_RELATIONS.refresh:
					with(existing_weather){
						current_duration = initial_duration
					}
					break;
				case WEATHER_RELATIONS.detonate:
					with(existing_weather){
						instance_destroy()
					}
					create_detonate_effect_object_at_location(pos_x, pos_y)
					
					break;
				
				case WEATHER_RELATIONS.fizzle:
				default:
					break;
			}	
		
		}
}

function create_weather_at_empty_space(pos_x, pos_y, weather_profile){
	var weather_instance = instance_create_layer(pos_x,pos_y,"Weather", weather_profile.weather_type)
	with(weather_instance){
		// Scale duration to number of players
		var nr_players=0;
		with(obj_control){
			nr_players= ds_list_size(ds_turn_order)
		}
			
		initial_duration = nr_players * weather_profile.weather_duration+1
		current_duration = initial_duration
		weather_element = weather_profile.weather_element	
	}

}

function create_detonate_effect_object_at_location(_x, _y){
	var instance = instance_create_layer(_x, _y, "Weather", obj_placeholder_detonate_weather_effect)
	with(instance){
		//Calculate when the attack should trigger
		var time_to_hit_frame = 1
		alarm[0] = time_to_hit_frame
	}
}