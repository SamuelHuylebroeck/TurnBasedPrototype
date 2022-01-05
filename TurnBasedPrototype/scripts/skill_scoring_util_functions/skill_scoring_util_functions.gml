//@description ??
function get_sum_preferred_targets(origin_unit, target, weather_profile){
	var count = 0
	var target_tiles = get_burst_target_positions(target._x,target._y, weather_profile.weather_burst_size);
	for(var i=0; i< ds_list_size(target_tiles);i++){
		var target_pos = target_tiles[| i]
		var unit_on_tile = instance_position(target_pos._x, target_pos._y, par_abstract_unit)
		if unit_on_tile != noone {
			var allied = is_unit_friendly(unit_on_tile, origin_unit.controlling_player)
			var preferred = (allied and weather_profile.benign) or (not allied and not weather_profile.benign)
			var weather_on_tile = instance_position(target_pos._x, target_pos._y, par_weather)
			if weather_on_tile != noone {
				var relation = global.weather_relations[weather_profile.weather_element][weather_on_tile.weather_element]
				preferred = ((preferred and (relation==WEATHER_RELATIONS.refresh or relation==WEATHER_RELATIONS.overpower)) or (relation==WEATHER_RELATIONS.detonate and not allied))
			}
			count = preferred ? count+1 : count-1
		}
	}
	return count

}