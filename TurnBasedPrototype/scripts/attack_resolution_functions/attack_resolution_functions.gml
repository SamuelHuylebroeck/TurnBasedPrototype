function create_attack_effect_objects(ds_attack_effect_objects, origin_unit, attack_profile){
	var targets
	switch (attack_profile.base_shape){
		case ATTACK_SHAPES.as_line:
		default:
			var targets = get_attack_line_target_positions(x,y, origin_unit, attack_profile);
	}
	for(var i=0; i< ds_list_size(targets);i++){
		var target_pos = targets[| i]
		create_attack_effect_object_at_location(i, target_pos._x, target_pos._y,  origin_unit, attack_profile);
		
	}
} 

function create_attack_effect_object_at_location(i, _x, _y, origin_unit, attack_profile){
	var instance = instance_create_layer(_x, _y, "Weather", obj_placeholder_attack_hit_effect)
	with(instance){
		//Calculate when the attack should trigger
		var time_to_hit_frame = attack_profile.animation_profile.hit_frame * origin_unit.image_speed / attack_profile.animation_profile.base_sprite_animation_speed * game_get_speed(gamespeed_fps)
		alarm[0] = time_to_hit_frame
	}
}

function end_attack(origin_unit){
	//Turn player control back on
	global.player_permission_execute_orders = true;
	//Mark unit as done
	origin_unit.has_acted_this_round = true;
}

function check_for_attack_end(origin_unit, ds_attack_effect_objects){
	attack_effects_done = true;
	origin_unit_done = origin_unit.current_state != UNIT_STATES.attacking
	return attack_effects_done and origin_unit_done

}