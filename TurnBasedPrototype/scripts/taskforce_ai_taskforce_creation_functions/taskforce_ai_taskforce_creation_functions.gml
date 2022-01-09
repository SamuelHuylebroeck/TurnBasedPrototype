function placeholder_max_out_taskforce(ai_player, taskforce_template, max_count){
	//Current count
	var count = 0
	for (var i=0; i< ds_list_size(ai_player.ds_list_taskforces); i++){
		tf_type = ai_player.ds_list_taskforces[|i].object_index
		if tf_type == taskforce_template {
			count++
		}
		
	}
	//Max up count
	if count < max_count{
		repeat(max_count - count){
			var new_tf = instance_create_layer(0,0,"Taskforces", taskforce_template)
			with(new_tf){
				taskforce_player = ai_player 
			}
			
			with(ai_player){
				ds_list_add(ds_list_taskforces, new_tf)
			}
		}
	}

}
	

//@description ??

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
				_x: middle._x + lengthdir_x(inner_radius/2, current_angle),
				_y: middle._y + lengthdir_y(inner_radius/2, current_angle),
				r: inner_radius/2
			}
			ds_queue_enqueue(queue_circles, new_circle)
			current_angle += step
		}
	}
	return queue_circles

}