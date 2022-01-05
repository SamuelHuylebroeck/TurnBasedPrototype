//@description ??
function draw_objectives_in_queue(ds_objective_queue){
	var copied_queue = ds_queue_create()
	ds_queue_copy(copied_queue, ds_objective_queue)
	while(not ds_queue_empty(copied_queue))
	{
		var objective = ds_queue_dequeue(copied_queue)
		if objective != undefined
			draw_objective(objective)
	}
	
	ds_queue_destroy(copied_queue)

}

function draw_objective(objective)
{
	switch(objective.objective_type){
		default:
			draw_capture_objective(objective, c_teal)
			break;
	}

}

function draw_capture_objective(objective, objective_colour){
	var old_color = draw_get_color()
	var old_alpha = draw_get_alpha()
	
	draw_set_color(objective_colour)
	draw_set_alpha(0.2)
	draw_circle(objective.target.x, objective.target.y, global.grid_cell_width/2, false)
	draw_set_alpha(0.7)
	draw_line_width_color(home_x,home_y, objective.target.x, objective.target.y, 3,c_blue, objective_colour)
	//draw_line_width_color(x,y, objective.target.x, objective.target.y, 3,c_red, objective_colour)

	draw_set_color(old_color)
	draw_set_alpha(old_alpha)

}
	
function log_recruitment_task_creation(template, position, player, taskforce, recruitment_building,cost){
	show_debug_message("---RT("+template.stats_name+"): " +string(cost) +"---")
	show_debug_message("P:" +string(player.id)+" TF: "+string(taskforce.id))
	var recruit_pos = {
		_x: floor(position._x/global.grid_cell_width),
		_y: floor(position._y/global.grid_cell_width)
	}
	show_debug_message("("+string(recruit_pos._x)+","+string(recruit_pos._y)+"): " +string(recruitment_building.id))
	show_debug_message("---/RT---")
}

function get_stance_verbose_name(stance){
	switch(stance){
		case TASKFORCE_STANCES.advancing:
			return "Advancing"
		case TASKFORCE_STANCES.mustering:
			return "Mustering"
		case TASKFORCE_STANCES.retreating:
			return "Retreating"
		default:
			return "Undefined"
	}
	
}