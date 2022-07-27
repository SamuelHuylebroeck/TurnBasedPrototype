/// @description ??
if initialized {
	
	var old_color = draw_get_color()
	var old_valign = draw_get_valign()
	var old_halign = draw_get_halign()
	
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var verbose_name = recruitment_option_detail.verbose_name;
	var cost = recruitment_option_detail.cost
	var width =max_width
	var height = min(string_height(verbose_name),max_width)
	
	
	
	var hover = is_mouse_hovering_over_gui_element(ui_x, ui_y, width, height)
	var click = hover && mouse_check_button_pressed(mb_left)

	var rect_color = text_base_colour
	if selected
	{
		rect_color = text_selected_colour
	}
	if hover {
		rect_color = text_highlight_colour
	}
	

	draw_set_color(rect_color)
	draw_rectangle(ui_x, ui_y, ui_x+width, ui_y+height, true)
	var recruitment_text = string(recruitment_option_detail.verbose_name) + ": " + string(recruitment_option_detail.cost)
	draw_text(ui_x, ui_y, recruitment_text)

	draw_set_color(old_color)

	if dialog != noone and not selected and click and visible
	{
		//put this option in focus
		with(dialog){
			select_for_recruitment(other.dialog_index)
		}
	}
}

