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
