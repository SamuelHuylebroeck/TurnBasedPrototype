//@description ??
function get_attack_damage_ceiling(origin_unit, tile, target,attack_profile){
	var targets = get_attack_target_tiles(tile._x, tile._y, target._x, target._y, origin_unit, attack_profile)
	
	var max_nr_of_targets = ds_list_size(targets)
	ds_list_destroy(targets)
	return max_nr_of_targets * attack_profile.base_damage
}
function get_attack_expected_damage(origin_unit,tile, target, attack_profile, friendly_fire_modifier){
	var total_damage = 0
	var target_tiles = get_attack_target_tiles(tile._x, tile._y, target._x, target._y, origin_unit, attack_profile)
	for(var i=0;i<ds_list_size(target_tiles);i++){
		var target_tile = target_tiles[|i]
		var unit_on_tile = instance_position(target_tile._x, target_tile._y, par_abstract_unit)
		if unit_on_tile != noone {
			var allied = is_unit_friendly(unit_on_tile, origin_unit.controlling_player)
			var simulated_result = simulate_attack(attack_profile,unit_on_tile,origin_unit)
			var expected_damage = simulated_result.damage * (simulated_result.hit_rate/100)
			if allied {
				expected_damage *= friendly_fire_modifier
			}
			if (global.debug_ai_raider_taskforces_scoring){
				show_debug_message(string(floor(target_tile._x/global.grid_cell_width))+","+string(floor(target_tile._y/global.grid_cell_width))+": "+string(expected_damage))
			}
			total_damage += expected_damage
		}
	}
	
	ds_list_destroy(target_tiles)
	return total_damage
}