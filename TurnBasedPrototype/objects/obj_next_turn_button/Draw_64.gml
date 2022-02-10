/// @description ??

var scale = global.ui_scale_values[global.current_ui_scale][0] * base_scale

width = scale * sprite_get_width(spr_next_turn_button);
height = scale *sprite_get_height(spr_next_turn_button);

margin = scale * base_margin


pos_x = display_get_gui_width() - width - margin;
pos_y = display_get_gui_height() - height - margin;


if(highlighted)
{
	draw_sprite_stretched(spr_next_turn_button,1,pos_x,pos_y, width, height);
}else
{
	draw_sprite_stretched(spr_next_turn_button,0,pos_x,pos_y, width, height);
}