/// @description execute recruitment
show_debug_message("Starting recruit task execution")
var new_unit = execute_recruitment(recruitment_details.position._x, recruitment_details.position._y, recruitment_details.recruitment_building,recruitment_details.template, recruitment_details.player, recruitment_details.cost)
//Add to taskforce
with(recruitment_details.taskforce){
	ds_list_add(ds_list_taskforce_units, new_unit)
}
alarm[3] = recruitment_delay/3*game_get_speed(gamespeed_fps)
