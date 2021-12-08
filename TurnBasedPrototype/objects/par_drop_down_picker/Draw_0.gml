/// @description ??
var width = option_width+sprite_get_width(icon_sprite)

var hover = is_mouse_hovering_over_rectangle(x, y, width, option_height)


// Draw option
draw_current_option(x,y,current_option)
// Draw icon sprite
var si = expanded ? 0:2 ;
if hover{
	si+= 1;
}
draw_sprite(icon_sprite, si, x+option_width, y)