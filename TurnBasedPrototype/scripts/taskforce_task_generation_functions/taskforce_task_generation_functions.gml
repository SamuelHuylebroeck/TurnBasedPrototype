//@description ??
function gather_task_force_executors(taskforce, executor_queue){
	//Loop over taskforce units and add all ready units to  queue
	for(var i=0; i<ds_list_size(taskforce.ds_list_taskforce_units);i++){
		var unit = taskforce.ds_list_taskforce_units[|i]
		if not unit.has_acted_this_round{
			ds_queue_enqueue(executor_queue,unit)
		}
	}

}
function get_next_task(unit, taskforce, player){
	var task_priority_queue = ds_priority_create()
	//Gather tile context
	var tile_context = get_unit_tile_context(unit)
	//For each tile in tile context, generate possible tasks and add them to queue
	generate_tasks_based_on_tile_context(unit, taskforce, player,tile_context, task_priority_queue)
	var next_task
	if ds_priority_size(task_priority_queue) <= 0 {
		next_task = noone
	}else{
		var next_task = ds_priority_delete_max(task_priority_queue)
			empty_task_priority_queue(task_priority_queue)
	}
	ds_priority_destroy(task_priority_queue)
	ds_queue_destroy(tile_context)
	return next_task
}

function get_unit_tile_context(unit){
	var context = ds_queue_create()
	//Prep the grid for this unit
	mp_grid_clear_all(global.map_grid)
	add_impassible_tiles_to_grid(unit)
	//Context contains every tile the unit can reach through movement
	var unit_movement = get_unit_movement_in_tiles(unit)
	var unit_pos = get_center_of_occupied_tile(unit)
	for(var i= -1*unit_movement; i<=unit_movement;i++){
		for(var j=-1*unit_movement; j<=unit_movement;j++){
			var manhatten_distance = abs(i)+abs(j)
			if (manhatten_distance <= unit_movement) {
				var tile_pos = {
					_x: unit_pos[0]+i*global.grid_cell_width,
					_y: unit_pos[1]+j*global.grid_cell_height
				}
			if can_navigate_unit(unit, global.map_grid, global.navigate, tile_pos._x, tile_pos._y)
				ds_queue_enqueue(context, tile_pos)
			}
		}
	}
	return context
}

function generate_tasks_based_on_tile_context(unit,taskforce,player, context_queue, task_priority_queue){
	if global.debug_ai show_debug_message("---Unit:"+string(unit)+"("+string(floor(unit.x/global.grid_cell_width))+","+string(floor(unit.y/global.grid_cell_height))+")---")
	while(not ds_queue_empty(context_queue)){
		var next_tile = ds_queue_dequeue(context_queue)
		if global.debug_ai show_debug_message("generating tasks for ["+string(floor(next_tile._x/global.grid_cell_width))+","+string(floor(next_tile._y/global.grid_cell_width))+"]")
		//Movement task
		generate_movement_action_for_tile(next_tile, unit, taskforce, player, task_priority_queue)
		//Movement+skill use task
		//Potential attacks
	
	}
	if global.debug_ai show_debug_message("---Unit:"+string(unit)+"---")
}

function generate_movement_action_for_tile(tile, unit, taskforce, player, task_priority_queue){
	var move_score = script_execute(taskforce.taskforce_action_scoring_function,ACTION_TYPES.move, unit,tile, taskforce)
	var move_task = instance_create_layer(0,0,"Logic", obj_move_task)
	with(move_task){
		self.unit = unit
		self.target_x = tile._x
		self.target_y = tile._y
	}
	ds_priority_add(task_priority_queue,move_task,move_score)
}

function empty_task_priority_queue(task_priority_queue){
	while(ds_priority_size(task_priority_queue)>0){
		var next_task_to_delete = ds_priority_delete_max(task_priority_queue)
		instance_destroy(next_task_to_delete)
	}
}