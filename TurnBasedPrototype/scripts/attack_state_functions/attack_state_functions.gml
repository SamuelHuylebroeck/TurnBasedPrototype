//@description ??
function execute_attack_state(){
	//Check for state transfer at the end of the attack
	if ( image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		image_index = 0
		sprite_index = animation_sprites[UNIT_STATES.idle]
		current_state = UNIT_STATES.idle
	
	}
}