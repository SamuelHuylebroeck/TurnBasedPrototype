//@description ??
function get_attack_line_target_positions(origin_x, origin_y, origin_unit, attack_profile){
	var targets = ds_list_create()
	ds_list_add(targets, {_x: origin_x, _y: origin_y})
	if (attack_profile.base_size > 1){
		var dir = point_direction(origin_unit.x, origin_unit.y, origin_x, origin_y)
		for(var i= 1; i<attack_profile.base_size;i++){
			var grid_x = lengthdir_x(i, dir)
			var grid_y = lengthdir_y(i, dir)
			ds_list_add(targets, {_x: origin_x+grid_x*global.grid_cell_width, _y: origin_y+ grid_y*global.grid_cell_height})

		}
	}
	return targets
}