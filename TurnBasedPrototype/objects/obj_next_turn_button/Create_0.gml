/// @description ??
var gui_element = self;
with(obj_control)
{
	ds_list_add(ds_gui_elements, gui_element);
}


highlighted = false;


#region initial setup
var scale = global.ui_scale_values[global.current_ui_scale][0] * base_scale

margin = scale * base_margin

width = min(scale * sprite_get_width(spr_next_turn_button), display_get_gui_width()*max_gui_width-2*margin);
height = scale *sprite_get_height(spr_next_turn_button);

pos_x = display_get_gui_width() - width - margin;
pos_y = display_get_gui_height() - height - margin;
#endregion