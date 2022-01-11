//@description ??
function take_task_force_ai_turn(taskforce_player){
	#region initialize
	if(global.ai_turn_in_progress == false){
		show_debug_message("Taking Taskforce AI turn")
		global.ai_turn_in_progress = true
		global.ai_turn_completed = false
		controller = instance_create_layer(0,0,"Logic", obj_ai_turn_controller)
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
		instance_destroy(controller)
		controller = noone
		alarm[0]=1

	
	}
	#endregion
	

}


function revoke_player_control(){
	global.player_permission_selection = false;
	global.player_permission_execute_orders = false;
	global.player_permission_click_next_turn = false;
	with(obj_next_turn_button){
		visible= false
	}
	with(obj_camera){
		player_in_control = false
		pan_camera_to_center_on_position(camera_get_view_x(camera)+camera_width/2,camera_get_view_y(camera)+camera_height/2,0.1)
	}

}

function restore_player_control(){
	global.player_permission_selection = true;
	global.player_permission_execute_orders = true;
	global.player_permission_click_next_turn = true;
	with(obj_next_turn_button){
		visible=true
	}
	with(obj_camera){
		player_in_control = true
	}

}

function execute_task_force_management(taskforce_player){
	show_debug_message("Executing task force and player stance management")
	#region task force creation
	var keys = ds_map_keys_to_array(taskforce_player.ds_map_force_max_composition)
	
	for (var i=0; i<array_length(keys);i++)
	{
		var max_count = ds_map_find_value(taskforce_player.ds_map_force_max_composition, keys[i])
		max_out_taskforce(taskforce_player, keys[i], max_count)
	}
	#endregion
	
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
	#region ai_player stance management
	
	update_player_stance(taskforce_player, grouped_map)
	#endregion
	
	#region task force objective checking
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
	if(not current_state_initialized){
		initialize_taskforce_recruitment(taskforce_player)
		current_state_initialized = true
	}

	if (current_task_executor.executor_state == TASK_STATES.done){
		instance_destroy(current_task_executor)
		current_task_executor = noone
		current_state_initialized = false
		current_state = AI_TURN_CONTROLLER_STATES.task_force_execution
	}	
	


}

function initialize_taskforce_recruitment(taskforce_player){
	show_debug_message("init recruitment")
	#region create and configure task executor
	current_task_executor = instance_create_layer(0,0,"Logic", obj_recruitment_task_executor)
	var executor_queue = current_task_executor.recruitment_task_queue
	#endregion
	#region gather all taskforce requests
	var request_list = ds_list_create()
	with(taskforce_player){
		for(var i=0; i<ds_list_size(ds_list_taskforces);i++){
			var tf = ds_list_taskforces[|i]
			if(global.debug_ai) show_debug_message("Generating recruitment requests for Taskforce " + string(tf)) 
			var request_queue = get_task_force_recruitment_request(tf, self.id)
			ds_list_add(request_list, request_queue)
		}
	}

	#endregion
	#region build a priority queue from all requests
	var rec_req_priority = construct_recruitment_priority_queue(request_list, taskforce_player)
	#endregion
	#region consume queue and create tasks and add them to the execution queue
	generate_recruitment_tasks(rec_req_priority, taskforce_player, executor_queue)
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
	
	current_task_executor.alarm[0] = 1
}

function execute_task_force_execution(taskforce_player){
	
	if(not current_state_initialized){
		initialize_taskforce_execution(taskforce_player)
		current_state_initialized = true
	}

	if (current_task_executor.executor_state == TASK_STATES.done){
		instance_destroy(current_task_executor)
		current_task_executor = noone
		current_state_initialized = false
		current_state = AI_TURN_CONTROLLER_STATES.done
	}	

}

function initialize_taskforce_execution(taskforce_player){
	show_debug_message("init unit execution")
	#region create and configure task executor
	current_task_executor = instance_create_layer(0,0,"Logic", obj_unit_task_executor)
	var taskforce_queue = current_task_executor.taskforce_queue
	#endregion

	#region Add all taskforces to the queue
	with(taskforce_player){
		for(var i=0; i<ds_list_size(ds_list_taskforces);i++){
			var tf = ds_list_taskforces[|i]
			ds_queue_enqueue(taskforce_queue, tf)
		}
	}
	
	#endregion
	current_task_executor.alarm[0] = 1
}

function update_player_stance(player, map_grouped_taskforces)
{
	#region explanation
	// A AI player starts the game in expansion stance, and will switch out of this stance into either aggressive or defensive when 90% of all structures is player controlled
	// An AI player will switch from aggresive to defensive when 75% of it's assault taskforces is in retreat or mustering
	// An AI player will switch from defensive to aggresive when 75% or more of it's assault taskforces are advancing
	#endregion
	switch(player.player_stance){
		case TASKFORCE_AI_STANCE.expanding:
			var total_nr_of_structures = 0
			var total_nr_of_controlled_structures = 0
			with(par_building){
				total_nr_of_structures++
				if(controlling_player != noone)total_nr_of_controlled_structures++
			}
			if total_nr_of_controlled_structures/total_nr_of_structures > 0.9 {
				player.player_stance = TASKFORCE_AI_STANCE.attacking
				update_player_stance(player, map_grouped_taskforces)
			}
			break;
		default:
			var list_assault_forces = ds_map_find_value(map_grouped_taskforces, obj_assault_taskforce)
			if list_assault_forces != undefined and ds_list_size(list_assault_forces) > 0
			{
				var total_nr_of_assault_forces = ds_list_size(list_assault_forces)
				var total_nr_of_advancing_assault_forces = 0
				for(var i=0; i<total_nr_of_assault_forces;i++)
				{
					var atf = list_assault_forces[|i]
					if atf.taskforce_stance == TASKFORCE_STANCES.advancing 
					{
						total_nr_of_advancing_assault_forces++
					}
				}
				var atf_fraction_advancing = total_nr_of_advancing_assault_forces/total_nr_of_assault_forces
				if player.player_stance == TASKFORCE_AI_STANCE.attacking and atf_fraction_advancing <=0.25
				{
					player.player_stance = TASKFORCE_AI_STANCE.defending
				}
				if player.player_stance == TASKFORCE_AI_STANCE.defending and atf_fraction_advancing >0.75
				{
					player.player_stance = TASKFORCE_AI_STANCE.attacking
				}
			}
			break;
	}
}