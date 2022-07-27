/// @description ??
if initialized {
	var old_color = draw_get_color()
	var old_valign = draw_get_valign()
	var old_halign = draw_get_halign()
	
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	draw_set_font(fonts[1])
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	
	width = max_width
	height = clamp(string_height(tab_text)+2*text_padding, min_height, max_height)
	
	#region highlight and click detection
	var highlighted = is_mouse_hovering_over_gui_element(ui_x, ui_y, width, height)
	var click = highlighted && mouse_check_button_pressed(mb_left)
	#endregion
	
	draw_sprite_stretched(spr_tab,highlighted?1:0,ui_x, ui_y, width, height)
	
	var text_colour = text_base_colour;
	if(selected)
	{
		text_colour = text_selected_colour
	}
	if(highlighted)
	{
		text_colour = text_highlight_colour
	}
	
	
	draw_set_color(text_colour)

	draw_text(ui_x+width/2, ui_y+height/2, tab_text)
	
	draw_set_color(old_color)
	draw_set_valign(old_valign)
	draw_set_halign(old_halign)
	
	if(dialog != noone and click and not selected and visible)
	{
		show_debug_message("switch tab")
		with(dialog)
		{
			switch_tab(other.tab_text, other.dialog_index)
		}
	}
}

