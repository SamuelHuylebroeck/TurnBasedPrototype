//Detect mouse

var width = option_width+sprite_get_width(icon_sprite)

var hover = is_mouse_hovering_over_rectangle(x, y, width, option_height)
var click = hover && mouse_check_button_pressed(mb_left)

if click{
	if not expanded {
		expand_picker()
	}
	else {
		collapse_picker()
	}
	
	
}
