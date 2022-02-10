function create_pause_page_visualization(page_grid){
	#region config to move
	var menu_font = font_menu_small
	var _y = 0.2*global.ui_height
	#endregion
	draw_set_font(menu_font)
	var element_height = string_height("Test")
	var nr_elements = ds_grid_height(page_grid)

	//Calculate some layout values
	var total_available_vertical_space = 0.8*global.ui_height
	var element_space_taken_up = nr_elements * element_height
	var free_margin_space = total_available_vertical_space - element_space_taken_up
	var element_bottom_margin = free_margin_space/nr_elements
	
	for(var i=0; i<nr_elements; i++)
	{
		var entry = instance_create_layer(0.48*global.ui_width,_y,"Logic", par_setting_entry)
		entry.entry_text = page_grid[# 0, i]
		create_setting_element_linked_control(0.52*global.ui_width,_y, entry, i, page_grid)
		_y += element_height+element_bottom_margin
		
	}
	vertical_seperator_height = (nr_elements-1)*(element_height + element_bottom_margin)

}


function destroy_pause_page_visualization(){
	with(par_setting_entry)
	{
		instance_destroy()
	}
	with(par_setting_control)
	{
		instance_destroy()
	}
}

#region element control creation

function create_setting_element_linked_control(_x,_y,setting_entry, page_index, page_grid)
{
	var type = page_grid[# 1, page_index]
	switch(type)
	{
		case menu_element_types.slider:
			return create_slider_setting_control(_x,_y, setting_entry,page_index, page_grid)
		case menu_element_types.toggle:
		case menu_element_types.shift:
			return create_shift_setting_control(_x,_y, setting_entry,page_index, page_grid)
		case menu_element_types.page_transfer:
			return create_page_transfer_setting_control(_x,_y, setting_entry,page_index, page_grid)
		case menu_element_types.script_runner:
			return create_script_runner_setting_control(_x,_y, setting_entry,page_index, page_grid)
		default:
			return noone
	}
}

function create_script_runner_setting_control(_x,_y,setting_entry, page_index, page_grid)
{
	var setting_control = instance_create_layer(_x,_y, "Logic", obj_setting_control_script_runner)
	with(setting_control)
	{
		linked_script = page_grid[# 2, page_index]
	}
	
	
	with(setting_entry){
		linked_control = setting_control
	}
	return setting_control
}

function create_page_transfer_setting_control(_x,_y,setting_entry, page_index, page_grid){
	var setting_control = instance_create_layer(_x,_y, "Logic", obj_setting_control_page_switch)
	
	with(setting_control)
	{
		target_page = page_grid[# 2, page_index]
	}
	
	with(setting_entry){
		linked_control = setting_control
	}
	return setting_control
}

function create_shift_setting_control(_x,_y,setting_entry, page_index, page_grid){
	var setting_control = instance_create_layer(_x,_y, "Logic", obj_setting_control_shift)
	
	with(setting_control)
	{
		options_array = page_grid[# 4, page_index]
		current_option_index = page_grid[# 3, page_index]
		apply_function = page_grid[# 2, page_index]
		settings_grid = page_grid
		settings_grid_row_index = page_index
		
	}
	
	with(setting_entry){
		linked_control = setting_control
	}
	return setting_control
}


function create_slider_setting_control(_x,_y,setting_entry, page_index, page_grid){
	var setting_control = instance_create_layer(_x,_y, "Logic", obj_setting_control_slider)
	
	with(setting_control)
	{
		min_value = page_grid[# 4, page_index][0]
		max_value = page_grid[# 4, page_index][1]
		current_value = (page_grid[# 3, page_index]-min_value)/(max_value-min_value)
		apply_function = page_grid[# 2, page_index]
		settings_grid = page_grid
		settings_grid_row_index = page_index
		
	}
	
	with(setting_entry){
		linked_control = setting_control
	}
	return setting_control
}
#endregion