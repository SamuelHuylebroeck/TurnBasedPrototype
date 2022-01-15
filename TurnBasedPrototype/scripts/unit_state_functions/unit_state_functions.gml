//@description ??
function execute_attack_state(){
	//Check for state transfer at the end of the attack
	if (end_of_animation_reached()){
		recover_to_idle()
	}
}

function execute_hurt_state(){
	//Check for state transfer at the end of the hurt
	if (end_of_animation_reached()){
		recover_to_idle()
	}
}

function execute_dying_state(){
	image_speed = 0
	image_index = 1
	image_alpha -= global.unit_fade_step
	if(image_alpha <= 0){
		instance_destroy()
	}
}

function recover_to_idle(){
		image_index = 0
		sprite_index = animation_sprites[UNIT_STATES.idle]
		current_state = UNIT_STATES.idle
}

function end_of_animation_reached(){
	return image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number
}
	
	
function resolve_moving_terrain_contact(unit, terrain)
{
	//Apply contact damage/healing
	if(terrain.contact_hp_change != 0){
		do_hp_change(unit, terrain.contact_hp_change)
	}
	//Aply contact boon and banes
}
function resolve_terrain_start_of_turn(unit,terrain){
	#region boon and bane
	if(terrain.start_of_turn_boon_bane != noone)
	{
		var bb_name = terrain.start_of_turn_boon_bane.verbose_name
		if ds_map_exists(unit.ds_boons_and_banes, bb_name )
		{
			// Refresh duration
			var boon_bane = ds_map_find_value(unit.ds_boons_and_banes, bb_name)
			boon_bane.current_duration = boon_bane.duration
		}else
		{
			//Add to map
			var boon_bane_copy = duplicate_boon_bane(terrain.start_of_turn_boon_bane)
			ds_map_add(unit.ds_boons_and_banes, boon_bane_copy.verbose_name, boon_bane_copy)
		}
	}
	#endregion
	
	#region hp_change
	if (terrain.start_of_turn_hp_change != 0) 
	{
		var hp_change = terrain.start_of_turn_hp_change * unit.unit_profile.max_hp
		do_hp_change(unit, hp_change)
	}
	#endregion

}