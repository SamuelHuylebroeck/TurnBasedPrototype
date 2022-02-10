/// @description ??
var text = options_array[current_option_index]
var option_length = array_length(options_array)
var text_width = string_width(text)
var x_margin = 4
var setting_font = font_menu_small
var font_color = c_soft_yellow
var arrow_scale = 2
var arrow_sprite_width = arrow_scale*sprite_get_width(spr_setting_arrow)
var arrow_sprite_height = arrow_scale*sprite_get_height(spr_setting_arrow)

#region mouse button capturing logic
//draw_circle(x,y,4, false)
var lmb_pressed = mouse_check_button_pressed(mb_left)
//draw_rectangle(x,y-arrow_sprite_height/2, x+text_width+2*(x_margin+arrow_sprite_width), y+arrow_sprite_height/2, true)
var mouse_over_element = is_mouse_hovering_over_gui_element(x,y-arrow_sprite_height/2, text_width +2*(arrow_sprite_width+x_margin), arrow_sprite_height)
//draw_rectangle(x,y-arrow_sprite_height/2, x+arrow_sprite_width, y+arrow_sprite_height/2, true)
var mouse_over_left_arrow = is_mouse_hovering_over_gui_element(x,y-arrow_sprite_height/2, arrow_sprite_width, arrow_sprite_height)
//draw_rectangle(x+arrow_sprite_width+x_margin+text_width+x_margin,y-arrow_sprite_height/2, x+arrow_sprite_width+x_margin+text_width+x_margin+arrow_sprite_width, y+arrow_sprite_height/2, true)
var mouse_over_right_arrow = is_mouse_hovering_over_gui_element(x+arrow_sprite_width+x_margin+text_width+x_margin,y-arrow_sprite_height/2, arrow_sprite_width, arrow_sprite_height)
#endregion

#region drawing
var old_halign = draw_get_halign()
var old_valign = draw_get_valign()
var old_font = draw_get_font()
var old_colour = draw_get_colour()

draw_set_valign(fa_middle)
draw_set_font(setting_font)
draw_set_color(font_color)
//Draw left arrow
draw_sprite_ext(spr_setting_arrow, mouse_over_left_arrow?1:0, x+arrow_sprite_width, y,-1*arrow_scale,arrow_scale,0,c_white,1)

//Draw center text
draw_text(x+arrow_sprite_width+x_margin,y, text)

//Draw right arrow
draw_sprite_ext(spr_setting_arrow, mouse_over_right_arrow?1:0,x+arrow_sprite_width+x_margin+text_width+x_margin, y,arrow_scale,arrow_scale,0,c_white,1)
#endregion 
#region process clicks
if lmb_pressed and mouse_over_element
{
	if mouse_over_left_arrow 
	{
		current_option_index--
		if current_option_index < 0 
		{
			current_option_index = option_length-1
		}
	}
	
	if mouse_over_right_arrow
	{
		current_option_index = (++current_option_index) % option_length
	}
	
	//Update using linked script
	var new_value = options_array[current_option_index]
	if apply_function != -1 {
		show_debug_message("Call update script here for new value: " + string(new_value))
		ds_grid_set(settings_grid,3, settings_grid_row_index, current_option_index)
		script_execute(apply_function, current_option_index)
	
	}
	
}
#endregion


draw_set_halign(old_halign)
draw_set_valign(old_valign)
draw_set_colour(old_colour)
draw_set_font(old_font)