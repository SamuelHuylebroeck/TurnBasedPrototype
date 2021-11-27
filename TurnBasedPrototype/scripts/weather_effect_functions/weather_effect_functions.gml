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