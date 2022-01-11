/// @description 
if initialized {
	var can_recruit = can_player_recruit(recruiting_player,recruitment_option_detail, recruitment_building)
	var hover = is_mouse_hovering_over_gui_element(ui_x, ui_y, button_width, button_height)
	var click = hover && mouse_check_button_pressed(mb_left)

	var rect_color = text_unavailable_colour
	
	if can_recruit {
		rect_color = text_base_colour
	}

	if hover and can_recruit{
		rect_color = text_highlight_colour
	}

	var old_color = draw_get_color()


	draw_set_color(rect_color)
	draw_rectangle(ui_x, ui_y, ui_x+button_width, ui_y+button_height, true)
	var recruitment_text = string(recruitment_option_detail.verbose_name) + ": " + string(recruitment_option_detail.cost)
	draw_text(ui_x, ui_y, recruitment_text)

	draw_set_color(old_color)

	if visible and click and can_recruit {
		//Create recruitment placement choices
		with(par_recruitment_dialog){
			visible = false
		}
		with(par_recruitment_option){
			visible= false
		}
		with(obj_recruitment_dialog_cancel){
			visible = false
		}
		create_recruitment_placement_opportunities(recruitment_building, recruitment_option_detail.unit,recruiting_player,recruitment_option_detail.cost)
	}
}