var scalar = max_value-min_value

var text = string(scalar*current_value + min_value)
var text_width = string_width(text)

var setting_font = font_menu_small
var font_color = c_soft_yellow
var slider_scale = 3
var x_margin = 2 *slider_scale
var slider_width = slider_scale *128
var slider_interior_width = slider_width-2*x_margin
var slider_height = slider_scale *16
var knob_sprite_width = slider_scale*sprite_get_width(spr_setting_slide_knob)
var knob_sprite_height = slider_scale*sprite_get_height(spr_setting_slide_knob)

var knob_x_pos_offset = x_margin+current_value*slider_interior_width


#region mouse button capturing logic
var lmb_check_pressed = mouse_check_button_pressed(mb_left)
var lmb_pressed = mouse_check_button(mb_left)
//draw_rectangle(x,y-slider_height/2, x+slider_width, y+slider_height/2, true)
var mouse_over_slider= is_mouse_hovering_over_gui_element(x,y-slider_height/2, slider_width, slider_height)
//draw_rectangle(x+knob_x_pos_offset-knob_sprite_width/2,y-knob_sprite_width/2, x+knob_x_pos_offset+knob_sprite_width/2, y+knob_sprite_height/2, true)
var mouse_over_knob = is_mouse_hovering_over_gui_element(x+knob_x_pos_offset-knob_sprite_width/2,y-knob_sprite_width/2, knob_sprite_width, knob_sprite_height)
#endregion

#region drawing
var old_halign = draw_get_halign()
var old_valign = draw_get_valign()
var old_font = draw_get_font()
var old_colour = draw_get_colour()

draw_set_valign(fa_middle)
draw_set_font(setting_font)
draw_set_color(font_color)
//Draw slider
draw_sprite_stretched(spr_setting_slider_slide,0, x, y-slider_height/2,slider_width, slider_height)
//Draw knob
draw_sprite_ext(spr_setting_slide_knob, mouse_over_knob?1:0,x+knob_x_pos_offset, y, slider_scale,slider_scale,0,c_white,1)
//Draw text
draw_text(x+slider_width+x_margin,y, text)
#endregion 
#region process clicks
if mouse_over_slider
{
	
	if lmb_check_pressed
	{
		var mouse_x_gui = device_mouse_x_to_gui(0)
		var lmb_rel_xpos = (mouse_x_gui-x)/slider_interior_width 
		current_value = clamp(lmb_rel_xpos, 0,1)
		old_x_pos = mouse_x_gui-x
		
		if apply_function != -1 
		{
			ds_grid_set(settings_grid,3, settings_grid_row_index, scalar*current_value+min_value)
			script_execute(apply_function,  scalar*current_value+min_value)
	
		}
	}
}

if mouse_over_knob and lmb_pressed
{
	//Have the knob move with the mouse
	var mouse_x_gui = device_mouse_x_to_gui(0)
	var shift = ((mouse_x_gui-x)-old_x_pos)/slider_interior_width
	old_x_pos = mouse_x_gui-x
	current_value = clamp(current_value+shift, 0,1)
	
	if apply_function != -1 
	{
		ds_grid_set(settings_grid,3, settings_grid_row_index, scalar*current_value+min_value)
		script_execute(apply_function, scalar*current_value+min_value)
	
	}
}
#endregion


draw_set_halign(old_halign)
draw_set_valign(old_valign)
draw_set_colour(old_colour)
draw_set_font(old_font)