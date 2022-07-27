/// @description ??
var scale = global.ui_scale_values[global.current_ui_scale][0]/2
width = scale * sprite_get_width(spr_cross)
height = scale * sprite_get_height(spr_cross)

var hover = is_mouse_hovering_over_gui_element(ui_x, ui_y, width, height)
var click = hover && mouse_check_button_pressed(mb_left)

draw_sprite_stretched(spr_cross, hover?1:0, ui_x, ui_y, width, height)


if click {
	cancel_recruitment()
}

