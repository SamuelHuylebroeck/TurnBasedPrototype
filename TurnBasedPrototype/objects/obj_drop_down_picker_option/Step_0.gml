/// @description ??
var hover = is_mouse_hovering_over_rectangle(x, y, w, h)
var click = hover && mouse_check_button_pressed(mb_left)

if hover{
	highlighted = true
}else{
	highlighted = false
}

if click {
	show_debug_message("Select option " + string(id))
	select_option(self.option, picker)
}