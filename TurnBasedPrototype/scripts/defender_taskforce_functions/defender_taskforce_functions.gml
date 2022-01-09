#region creation
function update_defender_taskforce_distribution(ai_player, max_count){
	//Current count
	var count = 0
	for (var i=0; i< ds_list_size(ai_player.ds_list_taskforces); i++){
		tf_type = ai_player.ds_list_taskforces[|i].object_index
		if tf_type == taskforce_template {
			count++
		}
		
	}
	
	//Loop over all
	with(obj_garrison_objective_tracker)
	{
		if is_garrison_objective_under_player_control(self, ai_player) and ds_map_find_value(map_assigned_taskforces, ai_player.id) == undefined
		{
			//This one is a potential new taskforce
			if count < max_count {
				//Create new defender taskforce and add it to the map
				var tf = create_defender_taskforce(self, ai_player)
				ds_map_add(map_assigned_taskforces, ai_player.id, tf)
				count++
			}
		}	
	
	}

}

function is_garrison_objective_under_player_control(go_tracker, player){
	with(go_tracker){
		for(var i=0; i <ds_list_size(list_nearby_structures);i++)
		{
			var structure = list_nearby_structures[|i]
			if structure.controlling_player == noone or structure.controlling_player.id != player.id 
			{
				return false
			}
		}
	}
	return true

}
#endregion

function create_defender_taskforce(garrison_objective_tracker,  taskforce_player){
	//Get the closest owned recruitment building
	var tf = instance_create_layer(garrison_objective_tracker.x, garrison_objective_tracker.y,"Taskforces", obj_defender_taskforce)
	var closest_recruitment_building = get_closest_controlled_recruitment_building(tf.x, tf.y, taskforce_player)
	with(tf){
		self.home_x = closest_recruitment_building.x
		self.home_y = closest_recruitment_building.y
		self.taskforce_player = taskforce_player
		self.taskforce_max_size = ds_list_size(garrison_objective_tracker.list_nearby_structures)+1
		var new_obj = new Objective(garrison_objective_tracker, OBJECTIVE_TYPES.guard)
		self.current_objective = new_obj
	}
	with(taskforce_player){
		ds_list_add(ds_list_taskforces, tf)
	}
	return tf
}

#region management

#endregion