/// @description Create Recruitment Opportunity
if (controlling_player != noone and current_state == BUILDING_STATES.ready) {

	var active_player = get_current_active_player()
	var occupying_unit = instance_position(x,y, par_abstract_unit)

	var do_recruitment = (controlling_player != noone and active_player != noone and active_player.id == controlling_player.id)
	do_recruitment = do_recruitment and occupying_unit == noone


	if do_recruitment 
	{
		show_debug_message("Start Up recruitment process here")
		start_recruitment(self)
	}

}