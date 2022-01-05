#region creation

#endregion
#region recruitment
function get_assault_taskforce_recruitment_request(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		repeat(2){
			var choice = choose(obj_unit_groundpounder, obj_unit_waveaxe, obj_unit_flamesword)
			var placeholder_request = {
				template: choice
				tf: taskforce
			}
			ds_queue_enqueue(ds_request_queue, placeholder_request)
		}
	}
}
#endregion
#region management
function update_objectives_all_assault_taskforces(ds_list_taskforces, ai_player){
	show_debug_message("Updating Assault taskforces")
	//Gather all contested flags
	var flag_list = get_all_contested_flags_list(ai_player)
	// Remove already claimed flags
	remove_all_claimed_flags(flag_list, ds_list_taskforces)
	// Assign each unclaimed element to a taskforce if possible
	var current_taskforce_index=0
	for(var i=0;i<ds_list_size(flag_list);i++){
		var next_flag_to_assign = flag_list[|i]
		current_taskforce_index = try_assign_flag_to_taskforce(next_flag_to_assign, ds_list_taskforces, current_taskforce_index)
	}
	// Loop over each taskforce and update stance+home area+objective completion
	for(var i = 0; i< ds_list_size(ds_list_taskforces); i++){
		var tf = ds_list_taskforces[| i]
		update_taskforce_stance(tf, ai_player)
		update_taskforce_home_area(tf, ai_player)
	}
}

function get_all_contested_flags_list(player){
	var flag_list = ds_queue_create()
	with(obj_flag){
		if controlling_player == noone or controlling_player.id != player.id
		{
			ds_list_add(flag_list, self)
		}
	
	}
	return flag_list
}

function remove_all_claimed_flags(flag_list, taskforce_list)
{
	var to_remove = ds_queue_create()
	for(var i=0;i<ds_list_size(taskforce_list);i++){
		var tf = taskforce_list[|i]
		if tf.current_objective != noone {
			//Check current objective
			var current_objective_flag = instance_position(tf.current_objective.target._x,tf.current_objective.target._y, obj_flag)
			if ds_list_find_index(flag_list, current_objective_flag) != -1{
				ds_queue_enqueue(to_remove, current_objective_flag)
			}
		}
		//Check objectives in queue
		check_objective_queue_for_claimed_flags(flag_list, to_remove, tf.ds_queue_taskforce_objectives)
	}
	//Remove all claimed flags
	while(not ds_queue_empty(to_remove)){
		var next_to_remove = ds_queue_dequeue(to_remove)
		var rm_pos = ds_list_find_index(flag_list, next_to_remove)
		ds_list_delete(flag_list, rm_pos)
	}
	ds_list_destroy(to_remove)

}

function check_objective_queue_for_claimed_flags(flag_list, to_remove_queue, objective_queue){
	var oq_copy = ds_queue_create()
	ds_queue_copy(oq_copy, objective_queue)
	while(not ds_queue_empty(oq_copy))
	{
		var next_objective = ds_queue_dequeue(oq_copy)
		var no_flag = instance_position(next_objective.target._x,next_objective.target._y, obj_flag)
		if ds_list_find_index(flag_list, no_flag) != -1{
			ds_queue_enqueue(to_remove_queue, no_flag)
		}
	}
}

function try_assign_flag_to_taskforce(flag, ds_list_taskforces, starting_position){
	var current_position =starting_position
	var tf_list_size = ds_list_size(ds_list_taskforces)
	repeat(tf_list_size){
		var next_candidate_tf = ds_list_taskforces[|current_position]
		// Can be assigned if there is space in the queue
		var available_space = next_candidate_tf.objective_queue_max_size - (ds_queue_size(next_candidate_tf.ds_queue_taskforce_objectives) + next_candidate_tf.current_objective==noone?0:1)
		if available_space > 0 
		{
			//Create new capture objective
		}
		current_position = (current_position+1)%tf_list_size
	}
	return current_position
}

#endregion
#region scoring
#endregion