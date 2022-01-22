/// @description terrain contact effects-
if(UNIT_STATES.moving){
	var terrain = other
	if(not ds_map_exists(ds_terrain_crossed, terrain.id)){
		//Add terrain to collision set and resolve contact effects
		//show_debug_message("Contact between U("+string(id)+") and T("+string(terrain.id)+")")
		resolve_moving_terrain_contact(self, terrain)
		ds_map_add(ds_terrain_crossed, terrain.id, terrain)
	}

}