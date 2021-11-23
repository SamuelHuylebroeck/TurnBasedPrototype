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