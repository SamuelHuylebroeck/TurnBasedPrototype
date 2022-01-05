//@description ??
function get_unit_movement_in_tiles(unit){
	with(unit){
		return move_points_total_current
	}
}

function is_armour_dominant_defense(unit){
	var rel_avoid = clamp(unit.unit_profile.base_avoid/global.max_avoid,0,1)
	var rel_armour = clamp(unit.unit_profile.base_armour/global.max_armour,0,1)
	return rel_armour > rel_avoid

}