//@description ??
function take_task_force_ai_turn(taskforce_player){
	#region initialize
	if(global.ai_turn_in_progress == false){
		show_debug_message("Taking Taskforce AI turn")
		global.ai_turn_in_progress = true
		global.ai_turn_completed = false
		var controller = instance_create_layer(0,0,"Logic", obj_ai_turn_controller)
		with(controller){
			linked_ai_player = taskforce_player
			active = true
		}
		revoke_player_control()
	
	}
	#endregion
	
	#region complete
	if(global.ai_turn_completed == true){
		show_debug_message("End Taskforce AI turn")
		global.ai_turn_in_progress = false
		global.ai_turn_completed = false
		restore_player_control()
		
		goto_next_turn()
	
	}
	#endregion
	

}


function revoke_player_control(){
	global.player_permission_selection = false;
	global.player_permission_execute_orders = false;

}

function restore_player_control(){
	global.player_permission_selection = true;
	global.player_permission_execute_orders = true;

}

function execute_task_force_management(taskforce_player){
	show_debug_message("Executing task force management")
	#region task force creation
	var keys = ds_map_keys_to_array(taskforce_player.ds_map_force_max_composition)
	
	for (var i=0; i<array_length(keys);i++)
	{
		var max_count = ds_map_find_value(taskforce_player.ds_map_force_max_composition, keys[i])
		max_out_taskforce(taskforce_player, keys[i], max_count)
	}
	#endregion
	
	#region task force objective checking
	
	//Group task forces together
	var grouped_map = ds_map_create()
	for (var i=0; i< ds_list_size(taskforce_player.ds_list_taskforces);i++){
		var tf = taskforce_player.ds_list_taskforces[|i]
		var key = tf.object_index
		if(ds_map_exists(grouped_map, key)){
			ds_list_add(ds_map_find_value(grouped_map, key), tf)
			
		}else{
			var new_list = ds_list_create()
			ds_list_add(new_list, tf)
			ds_map_add(grouped_map, key, new_list)
		}
	}
	// Run the grouped forces through the objective updates
	var key_array = ds_map_keys_to_array(grouped_map)
	for(var i=0; i<array_length(key_array);i++){
		var key = key_array[i]
		var map_list = ds_map_find_value(grouped_map, key)
		update_objectives(taskforce_player, key, map_list)
		//Clean up map and list
		ds_map_delete(grouped_map, key)
		ds_list_clear(map_list)
		ds_list_destroy(map_list)
	
	}
	ds_map_destroy(grouped_map)
	#endregion
	current_state = AI_TURN_CONTROLLER_STATES.recruitment
}

function execute_taskforce_recruitment(taskforce_player){
	show_debug_message("Executing recruitment")
	#region gather all taskforce requests
	var request_list = ds_list_create()
	with(taskforce_player){
		for(var i=0; i<ds_list_size(ds_list_taskforces);i++){
			var tf = ds_list_taskforces[|i]
			var request_queue = get_task_force_recruitment_request(tf, self.id)
			ds_list_add(request_list, request_queue)
		}
	}

	#endregion
	#region build a priority queue from all requests
	var rec_req_priority = construct_recruitment_priority_queue(request_list, taskforce_player)
	#endregion
	#region consume queue and create tasks and add them to the execution queue
	generate_recruitment_tasks(rec_req_priority, taskforce_player)
	#endregion
	#region cleanup
	for(var i=0; i<ds_list_size(request_list);i++)
	{
		var request_queue = request_list[|i]
		ds_queue_destroy(request_queue)
	}
	ds_list_destroy(request_list)
	ds_priority_destroy(rec_req_priority)
	
	#endregion
	current_state = AI_TURN_CONTROLLER_STATES.task_force_execution


}

function execute_task_force_execution(taskforce_player){
	show_debug_message("Executing task force execution")
	current_state = AI_TURN_CONTROLLER_STATES.done

}