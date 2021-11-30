//@description ??
function get_current_active_player(){
	with(obj_control)
	{
		if ds_list_size(ds_turn_order) > 0 {
			return  ds_turn_order[| current_active_player_index]
		} else {
			return noone
		}
	}

}