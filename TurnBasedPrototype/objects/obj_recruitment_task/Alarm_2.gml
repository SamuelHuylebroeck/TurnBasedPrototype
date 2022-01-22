/// @description execute recruitment
if global.debug_ai_recruitment show_debug_message("Starting recruit task execution")
if can_recruit(recruitment_details.template, recruitment_details.cost, recruitment_details.player){
	var new_unit = execute_recruitment(recruitment_details.position._x, recruitment_details.position._y, recruitment_details.recruitment_building,recruitment_details.template, recruitment_details.player, recruitment_details.cost)
	//Add to taskforce
	with(recruitment_details.taskforce)
	{
		new_unit.linked_taskforce = self.id
		ds_list_add(ds_list_taskforce_units, new_unit)
		if global.debug_ai_recruitment show_debug_message("Unit " +string(new_unit.id) + " has been added to taskforce " + string(self.id))
	}
}
alarm[3] = recruitment_delay/3*game_get_speed(gamespeed_fps)
