//@description ??
function goto_next_turn(){
	resolve_turn_end(ds_turn_order[| current_active_player_index])
	//Advance to next player
	current_active_player_index++
	if (current_active_player_index>=ds_list_size(ds_turn_order)){
		current_active_player_index = current_active_player_index%ds_list_size(ds_turn_order)
		current_round++
		resolve_round_end()
	}
}

function resolve_turn_end(player){
	if (player != noone){
		//Loop over every unit
		with(par_abstract_unit){
			if(controlling_player != noone and controlling_player.id == player.id){
				//Remove activation marker
				has_acted_this_round = false;
				//Resolve boons and hexes
				//Restore Movement Points
				move_points_pixels_curr = move_points_pixels;
			}
	
		}
	}

}

function resolve_round_end(){
	//Resolve weather effects
	with(par_weather){
		current_duration--
		if(current_duration <=0){
			fade_weather()
		}
	
	}
	//Check for EoG scoring

}