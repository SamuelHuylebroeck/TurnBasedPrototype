/// @description Highlight
var active_player = get_current_active_player()
var unit_over_mouse = instance_position(mouse_x, mouse_y,par_abstract_unit)
if (active_player != noone 
	and controlling_player != noone 
	and controlling_player.id == active_player.id 
	and global.player_permission_execute_orders
	and not unit_over_mouse)
{
	highlighted = true
}