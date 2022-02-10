var arrow_width = sprite_width * scale
var arrow_height = sprite_height * scale

#region mouse button capturing logic
var lmb_check_pressed = mouse_check_button_pressed(mb_left)
var mouse_over_arrow= is_mouse_hovering_over_gui_element(x,y-arrow_height/2, arrow_width, arrow_height)

#endregion


draw_sprite_ext(sprite_index, mouse_over_arrow ? 1: 0 , x,y,scale,scale, 0, c_white, 1)

if mouse_over_arrow and lmb_check_pressed
{
	show_debug_message("Execute page transfer")
	if target_page != -1 
		{
		var pause_menu;
		with(par_settings_menu)
		{
			pause_menu = self
		}
		goto_settings_page(pause_menu, target_page)
	}
}