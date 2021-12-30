//@description ??
function raider_taskforce_action_scoring_function(action_type, unit, tile, taskforce){
	switch(action_type){
		default:
			return raider_taskforce_score_move(unit, tile, taskforce)	
	
	}
}

function raider_taskforce_score_move(unit, tile, taskforce){
	switch(taskforce.taskforce_stance){
		default:
			return raider_taskforce_score_move_advancing(unit, tile,taskforce)
		
	}
}

function raider_taskforce_score_move_advancing(unit, tile,taskforce){
	#region Score explanation
	//AAAAAABB
	//AAAAAA is scored based on how close this tile is to the next objective, with  the objective tile itself having max score
	//BB is scored based on the euclidean distance towards the target
	#endregion
	var objective_x = taskforce.current_objective.target.x
	var objective_y = taskforce.current_objective.target.y
	var compound_score = 0
	//Calculate length of path from tile to objective
	//Prep the grid for this unit
	mp_grid_clear_all(global.map_grid)
	add_impassible_tiles_to_grid(unit)
	var path_length = get_path_length(global.map_grid,global.navigate, tile._x,tile._y, objective_x, objective_y)
	var max_distance = global.grid_nr_h_cells*global.grid_nr_v_cells*global.grid_cell_width
	var rel_objective_distance_score = (max_distance-path_length)/max_distance 
	rel_objective_distance_score = floor(rel_objective_distance_score* power(10,6))*power(10,2)
	compound_score +=rel_objective_distance_score
	
	var euclidean_distance = point_distance(tile._x,tile._y, taskforce.current_objective.target.x, taskforce.current_objective.target.y)
	var max_euclidean_distance = sqrt(room_width*room_width+room_height*room_height)
	var euclid_distance_score = (max_euclidean_distance-euclidean_distance)/max_euclidean_distance *power(10,2)
	compound_score += euclid_distance_score
		
	if global.debug_ai_raider_taskforces {
		show_debug_message("Score for tile ["+string(floor(tile._x/global.grid_cell_width))+","+string(floor(tile._y/global.grid_cell_height))+ "] Towards objective ["+string(floor(objective_x/global.grid_cell_width))+","+string(floor(objective_y/global.grid_cell_height))+"]")
		show_debug_message("compound: "+string(compound_score))
		show_debug_message("dist to objective: "+string(rel_objective_distance_score))
	}
	
	return compound_score
}