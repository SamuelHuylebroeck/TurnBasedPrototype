/// @description ??
var gui_element = self;
with(obj_control)
{
	ds_list_add(ds_gui_elements, gui_element);
}

highlighted = false;
width = sprite_get_width(spr_next_turn_button);
height = sprite_get_height(spr_next_turn_button);
margin = 16;

pos_x = display_get_gui_width() - width - margin;
pos_y = display_get_gui_height() - height - margin;