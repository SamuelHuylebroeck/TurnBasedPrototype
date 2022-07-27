if initialized {
	var old_color = draw_get_color()
	var old_valign = draw_get_valign()
	var old_halign = draw_get_halign()
	
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	draw_set_font(fonts[1])
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	
	width = max_width
	height = clamp(string_height(recruit_text)+2*text_padding, min_height, max_height)
	
	#region highlight and click detection
	var highlighted = is_mouse_hovering_over_gui_element(ui_x, ui_y, width, height)
	var click = highlighted && mouse_check_button_pressed(mb_left)
	#endregion
	
	draw_sprite_stretched(spr_tab,highlighted?1:0,ui_x, ui_y, width, height)
	
	var text_colour = text_base_colour;
	if(highlighted)
	{
		text_colour = text_highlight_colour
	}
	if(not selection_recruitable)
	{
		text_colour = text_unavailable_colour
	}
	
	
	draw_set_color(text_colour)

	draw_text(ui_x+width/2, ui_y+height/2, recruit_text)
	
	draw_set_color(old_color)
	draw_set_valign(old_valign)
	draw_set_halign(old_halign)
	
	if(dialog != noone and click and selection_recruitable and visible)
	{
		show_debug_message("Recruitment Time")
		with(dialog)
		{
		with(obj_tabbed_recruitment_cancel){
			visible = false
		}
		with(obj_tabbed_recruitment_dialog){
			visible= false
		}
		with(obj_tabbed_recruitment_preview){
			visible = false
		}
		with(obj_tabbed_recruitment_recruit_button){
			visible = false
		}
		with(obj_tabbed_recruitment_recruit_option){
			visible = false
		}
		with(obj_tabbed_recruitment_tab){
			visible = false
		}
			
		var option = ds_current_active_options[|current_active_option]
		create_recruitment_placement_opportunities(option.recruitment_building, option.recruitment_option_detail.unit, option.recruiting_player, option.recruitment_option_detail.cost)
		}
	}
}