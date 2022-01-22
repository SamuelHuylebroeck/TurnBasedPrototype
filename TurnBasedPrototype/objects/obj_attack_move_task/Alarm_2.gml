/// @description ??
attack_started = true
if instance_exists(target_unit){
	clean_up_attack_preview()
	var center = get_center_of_occupied_tile(target_unit)
	if global.debug_ai_execution show_debug_message("Executing attack task towards: ["+string(floor(center[0]/global.grid_cell_width))+","+string(floor(center[1]/global.grid_cell_height))+"]")

	attack_orchestrator = instance_create_layer(center[0],center[1],"Units",obj_attack_orchestrator)
	with(attack_orchestrator){
		linked_attacker = other.unit
		linked_attack_profile = other.linked_attack_profile
		alarm[0]=1
	}
}