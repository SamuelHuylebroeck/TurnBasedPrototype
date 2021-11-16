//@description ??
function goto_next_turn(){
	current_active_player_index++
	if (current_active_player_index>=ds_list_size(ds_turn_order)){
		current_active_player_index = current_active_player_index%ds_list_size(ds_turn_order)
		current_turn++
	}
}