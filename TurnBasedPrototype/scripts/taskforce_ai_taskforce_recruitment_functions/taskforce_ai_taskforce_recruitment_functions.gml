//@description ??
function get_task_force_recruitment_request(taskforce, taskforce_player){
	var ds_tf_request_queue = ds_queue_create()
	switch(taskforce.object_index){
		default:
			get_taskforce_recruitment_request_placeholder(ds_tf_request_queue,taskforce, taskforce_player)
			break;
	}
	
	return ds_tf_request_queue

}

function get_taskforce_recruitment_request_placeholder(ds_request_queue, taskforce, taskforce_player){
	var placeholder_request = {
		template: obj_unit_flamesword,
		tf: taskforce
		}
	ds_queue_enqueue(ds_request_queue, placeholder_request)

}

function construct_recruitment_priority_queue(ds_requests_list, taskforce_player){
	var priority_queue = ds_priority_create()
	//loop over list
	for(var i = 0 ; i<ds_list_size(ds_requests_list); i++){
		var request_queue = ds_requests_list[|i]
		//empty queue
		var pos_in_queue = 0;
		while(not ds_queue_empty(request_queue))
		{
			//calculate priority for each request and add to queue
			var next_request = ds_queue_dequeue(request_queue);
			var priority_score = get_recruit_priority_score(next_request,taskforce_player, pos_in_queue,i);
			ds_priority_add(priority_queue,next_request, priority_score)
			pos_in_queue++
		}
	}

	
	return priority_queue

}
function get_recruit_priority_score(recruit_request, taskforce_player, queue_position, list_position){
	#region score explanation
	//Score is ABCCDD
	// A is derived from the matrix combining the taskforce state and player state
	// B is derived from the matrix combining the taskforce type and player state
	// C is derived from the position of the recruitment opportunity in it's task force queue
	// D is derived from the position of the taskforce queue
	#endregion
	var compound_score = 0
	compound_score += score_taskforce_state(recruit_request.tf, taskforce_player)*100000
	compound_score += score_taskforce_type(recruit_request.tf, taskforce_player)*10000
	compound_score += (99-queue_position)*100
	compound_score += (99-list_position)
	
	return compound_score
}

function score_taskforce_state(taskforce, player){
	return player.recruitment_stance_matrix[player.player_stance][taskforce.taskforce_stance]
}

function score_taskforce_type(taskforce, player){
	return player.recruitment_type_matrix[player.player_stance][taskforce.taskforce_type]
}

function generate_recruitment_tasks(rec_req_priority, taskforce_player){
	#region gather up available recruitment buildings
	var ds_list_recruitment_buildings = ds_list_create()
	with(par_recruitment_building){
		if(controlling_player != noone and controlling_player.id == taskforce_player.id and current_state = BUILDING_STATES.ready){
			ds_list_add(ds_list_recruitment_buildings, id)
		}
	}
	#endregion
	while(not ds_priority_empty(rec_req_priority) and not ds_list_empty(ds_list_recruitment_buildings))
	{
		var next_opportunity = ds_priority_delete_max(rec_req_priority)
		var cost = get_unit_cost(next_opportunity.template, taskforce_player)
		if can_recruit(next_opportunity.template,cost, taskforce_player)
		{
			var selected_building = select_closest_available_recruitment_building(next_opportunity, ds_list_recruitment_buildings)
			var index_to_remove = ds_list_find_index(ds_list_recruitment_buildings, selected_building)
			ds_list_delete(ds_list_recruitment_buildings, index_to_remove)
			create_recruitment_task_from_opportunity(next_opportunity.template, taskforce_player, next_opportunity.tf, selected_building, cost)
		}
	}
	ds_list_destroy(ds_list_recruitment_buildings)
}

function get_unit_cost(template, player){
	//Todo replace with cost sourced from player
	return 100

}

function can_recruit(template, cost, player){
	return cost <= player.player_current_resources
}
function select_closest_available_recruitment_building(opportunity, ds_list_buildings){
	//Closest to the taskforce's current objective, or it's home if the objective is missing
	var  position_to_consider = {
		_x: opportunity.tf.home_x,
		_y: opportunity.tf.home_y
	}
	if opportunity.tf.current_objective != noone {
		position_to_consider ={
			_x: opportunity.tf.current_objective.target.x,
			_y: opportunity.tf.current_objective.target.y
		}
	}
	var closest_building = noone
	var closest_distance = room_width*room_width + room_height*room_height
	for(var i = 0; i<ds_list_size(ds_list_buildings);i++)
	{
		var building = ds_list_buildings[|i]
		var distance = point_distance(position_to_consider._x, position_to_consider._y,building.x, building.y)
		if distance < closest_distance{
			closest_distance = distance
			closest_building = building
		}
	}
	
	return closest_building
}

function create_recruitment_task_from_opportunity(template, player, taskforce, recruitment_building, cost){
	if (global.debug_ai) log_recruitment_task_creation(template, player, taskforce, recruitment_building, cost)

}