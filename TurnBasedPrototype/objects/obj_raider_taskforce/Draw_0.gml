/// @description ??
// Draw TF itself
if global.debug_ai {
	var old_halign = draw_get_halign()
	var old_alpha = draw_get_alpha()
	var old_font = draw_get_font()
	draw_set_alpha(0.2)
	draw_circle_color(x,y,global.grid_cell_width/2, c_yellow, c_yellow, false)
	draw_set_halign(fa_middle)
	draw_set_alpha(old_alpha)
	draw_set_font(font_attack_preview)
	draw_text_color(x,y,"Raiders " + string(id), c_white, c_white,c_white,c_white, 1)
	var stance_string = get_stance_verbose_name(taskforce_stance)
	draw_text_color(x,y+8, stance_string,c_white,c_white, c_white, c_white,1)
	draw_set_halign(old_halign)
	draw_set_font(old_font)
}
if global.debug_ai and global.debug_ai_raider_taskforces {
	//Draw home zone
	var old_alpha = draw_get_alpha()
	draw_set_alpha(0.1)
	draw_circle_color(home_x,home_y,global.grid_cell_width*taskforce_homezone_tile_radius, c_green, c_yellow, false)
	draw_set_alpha(0.2)
	draw_circle_color(home_x,home_y,global.grid_cell_width/2, c_red, c_yellow, false)
	draw_line_width_color(x,y,home_x, home_y,2, c_green, c_green)
	//Draw ZOI
	//draw_set_alpha(0.1)
	//draw_circle_color(x,y,zoi_tile_radius * global.grid_cell_width, c_yellow, c_red, false)
	draw_set_alpha(old_alpha)
	//Draw current objective
	if current_objective != noone {
		draw_capture_objective(current_objective, c_green)
	}
	//Draw objectives in queue
	draw_objectives_in_queue(ds_queue_taskforce_objectives)
	//Draw units
	for(var i=0; i<ds_list_size(ds_list_taskforce_units);i++){
		var unit = ds_list_taskforce_units[|i]
		if instance_exists(unit)
		{
			draw_line_width_color(x,y,unit.x, unit.y,2, c_blue, c_green)
		}
	}
	
}