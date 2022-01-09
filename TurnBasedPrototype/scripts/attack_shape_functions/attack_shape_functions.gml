//@description ??
function get_attack_line_target_positions(origin_x, origin_y, target_x, target_y, origin_unit, attack_profile){
	var targets = ds_list_create()
	ds_list_add(targets, {_x: target_x, _y: target_y})
	if (attack_profile.base_size > 1){
		var dir = point_direction(origin_x, origin_y, target_x, target_y)
		for(var i= 1; i<attack_profile.base_size;i++){
			var grid_x = lengthdir_x(i, dir)
			var grid_y = lengthdir_y(i, dir)
			ds_list_add(targets, {_x: target_x+grid_x*global.grid_cell_width, _y: target_y+ grid_y*global.grid_cell_height})

		}
	}
	return targets
}

function get_attack_cone_target_positions(origin_x, origin_y, target_x, target_y, origin_unit, attack_profile){
	var targets = ds_list_create()
	ds_list_add(targets, {_x: target_x, _y: target_y})
	if (attack_profile.base_size > 1){
		var dir = point_direction(origin_x, origin_y, target_x, target_y)
		for(var i= 1; i<attack_profile.base_size;i++){
			//Add middle
			var grid_x = lengthdir_x(i, dir)
			var grid_y = lengthdir_y(i, dir)
			var middle = {_x: target_x+grid_x*global.grid_cell_width, _y: target_y+ grid_y*global.grid_cell_height }
			ds_list_add(targets, {_x: middle._x, _y: middle._y})

			var perpendicular_direction = dir+90
			var counter = 1
			repeat(i){
			
				//Add left
				var grid_x = lengthdir_x(counter, perpendicular_direction)
				var grid_y = lengthdir_y(counter, perpendicular_direction)
				ds_list_add(targets, {_x: middle._x+grid_x*global.grid_cell_width, _y: middle._y+ grid_y*global.grid_cell_height})
				//Add right
				var grid_x = lengthdir_x(-counter, perpendicular_direction)
				var grid_y = lengthdir_y(-counter, perpendicular_direction)
				ds_list_add(targets, {_x: middle._x+grid_x*global.grid_cell_width, _y: middle._y+ grid_y*global.grid_cell_height})

				counter++
			}
		}
	}
	return targets

}

function get_attack_burst_target_positions(origin_x, origin_y, target_x, target_y, origin_unit, attack_profile){
	return get_burst_target_positions(origin_x, origin_y, attack_profile.base_size)
}

function get_burst_target_positions(origin_x, origin_y, burst_size){
	var targets = ds_list_create();
	var max_consider_range = ceil(burst_size);
	for(var i=-1*max_consider_range;i<=max_consider_range;i++)
	{
		for(var j=-max_consider_range; j<=max_consider_range; j++)
		{
			if (not (i==0 and j==0)){
				if(i*i + j*j <= burst_size*burst_size)
				{
					ds_list_add(targets, {_x: origin_x+i*global.grid_cell_width, _y: origin_y+ j*global.grid_cell_height})
					
				}
			}
	
		}
	}
	return targets
}

function get_attack_blast_target_positions(target_x, target_y, origin_unit, attack_profile){
	return get_blast_target_positions(target_x, target_y, attack_profile.base_size)
}



function get_blast_target_positions(target_x, target_y, burst_size){
	var targets = ds_list_create();
	var max_consider_range = ceil(burst_size);
	for(var i=-1*max_consider_range;i<=max_consider_range;i++)
	{
		for(var j=-max_consider_range; j<=max_consider_range; j++)
		{
			if(i*i + j*j <= burst_size*burst_size)
			{
				ds_list_add(targets, {_x: target_x+i*global.grid_cell_width, _y: target_y+ j*global.grid_cell_height})
					
			}
		}
	}
	return targets
}