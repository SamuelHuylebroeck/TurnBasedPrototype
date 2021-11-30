/// @description Highlight
var active_player = get_current_active_player()
var occupying_unit = instance_position(x,y, par_abstract_unit)
if (active_player != noone and occupying_unit == noone and controlling_player != noone and controlling_player.id == active_player.id)
{
	highlighted = true
}