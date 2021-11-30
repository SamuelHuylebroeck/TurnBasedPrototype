/// @description Draw cancel text
var hover = is_mouse_hovering_over_gui_element(ui_x, ui_y, button_width, button_height)
var click = hover && mouse_check_button_pressed(mb_left)

var rect_color = text_base_colour

if hover{
	rect_color = text_highlight_colour
}

var old_color = draw_get_color()


draw_set_color(rect_color)
draw_rectangle(ui_x, ui_y, ui_x+button_width, ui_y+button_height, true)
draw_text(ui_x, ui_y, ui_text)

draw_set_color(old_color)

if click {
	cancel_recruitment()

}