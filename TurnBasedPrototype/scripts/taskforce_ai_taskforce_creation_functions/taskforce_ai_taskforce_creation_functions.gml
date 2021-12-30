//@description ??
function create_raider_taskforce(pos_x, pos_y, zoi_radius, taskforce_player){
	//Get the closest owned recruitment building
	var tile_center = get_center_of_tile_for_pixel_position(pos_x, pos_y)
	var tf = instance_create_layer(tile_center[0], tile_center[1],"Taskforces", obj_raider_taskforce)
	var closest_recruitment_building = get_closest_controlled_recruitment_building(tile_center[0], tile_center[1], taskforce_player)
	with(tf){
		self.home_x = closest_recruitment_building.x
		self.home_y = closest_recruitment_building.y
		self.zoi_tile_radius = floor(zoi_radius / global.grid_cell_width)
		self.taskforce_player = taskforce_player
	}
	with(taskforce_player){
		ds_list_add(ds_list_taskforces, tf)
	}
}

function get_closest_controlled_recruitment_building(pos_x, pos_y, player){
	var closest = noone
	var closest_distance = room_width*room_width + room_height*room_height +1
	with(par_recruitment_building){
		if controlling_player != noone and controlling_player.id == player.id
		{
			var distance = point_distance(pos_x,pos_y, x,y)
			if distance < closest_distance{
				closest = self
				closest_distance = distance
			}
		}
	
	}
	return closest
}

 
function max_out_raider_taskforces_radial_distribution(taskforce_player, max_count){
	#region Get positions and zone of interests
	var dir = point_direction(taskforce_player.x, taskforce_player.y, room_width/2, room_height/2)
	var distributions = get_radial_distribution_on_map(dir, max_count)
	#endregion
	
	while(not ds_queue_empty(distributions))
	{
		var next_area = ds_queue_dequeue(distributions)
		
		if(not raider_task_force_occupies_zone(taskforce_player.ds_list_taskforces,next_area._x, next_area._y)){
			#region Create new one
			create_raider_taskforce(next_area._x, next_area._y, next_area.r,taskforce_player)
			#endregion
		
		}else{
			#region potentially update old one
			#endregion
		}
	}
	ds_queue_destroy(distributions)
}

function raider_task_force_occupies_zone(ds_list_taskforces, zone_x,zone_y){
	var result = false;
	var justified_zone_coordinates= get_center_of_tile_for_pixel_position(zone_x,zone_y)
	for(var i=0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[|i]
		if tf.x == justified_zone_coordinates[0] and tf.y == justified_zone_coordinates[1]
		{
			return true
		}
	}
	return result

}

function get_radial_distribution_on_map(offset_angle, nr_sections){
	var queue_circles = ds_queue_create()
	// get the middle
	var middle = {
		_x: room_width/2,
		_y: room_height/2
	};
	// get smallest max of the smallest of the axi
	var inner_radius = min(room_width/2, room_height/2)
	var outer_radius = point_distance(0,0,room_width, room_height)/2
	if nr_sections = 1{
		var single_distribution = {
			_x: middle._x,
			_y: middle._y,
			r: outer_radius/2
		}
		ds_queue_enqueue(queue_circles, single_distribution)
	}else{
		var step = 360/nr_sections
		var current_angle = offset_angle
		repeat(nr_sections){
			var new_circle ={
				_x: middle._x + lengthdir_x(2*inner_radius/3, current_angle),
				_y: middle._y + lengthdir_y(2*inner_radius/3, current_angle),
				r: outer_radius/2
			}
			ds_queue_enqueue(queue_circles, new_circle)
			current_angle += step
		}
	}
	return queue_circles

}