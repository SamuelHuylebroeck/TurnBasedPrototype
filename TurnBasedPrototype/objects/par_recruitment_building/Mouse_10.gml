/// @description Highlight
var active_player = get_current_active_player()
if (active_player != noone and controlling_player != noone and controlling_player.id == active_player.id and global.player_permission_execute_orders)
{
	highlighted = true
}