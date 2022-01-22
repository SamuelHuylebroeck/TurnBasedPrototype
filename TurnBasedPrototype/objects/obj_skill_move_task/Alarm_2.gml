/// @description ??
skill_started = true
clean_up_attack_preview()
var center = get_center_of_occupied_tile(unit)
if global.debug_ai_execution show_debug_message("Executing create weather task on: ["+string(floor(center[0]/global.grid_cell_width))+","+string(floor(center[1]/global.grid_cell_height))+"]")

skill_orchestrator = instance_create_layer(center[0],center[1],"Units",obj_create_weather_orchestrator)
with(skill_orchestrator){
	linked_weather_profile = other.linked_weather_profile
	linked_unit = other.unit
	alarm[0]=1

}