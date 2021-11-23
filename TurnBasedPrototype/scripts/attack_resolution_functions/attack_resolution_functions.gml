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
		// Set the required data
		linked_attack_profile = attack_profile
		linked_attacker = origin_unit
	}
}

function end_attack(origin_unit){
	//Turn player control back on
	global.player_permission_execute_orders = true;
	//Mark unit as done
	origin_unit.has_acted_this_round = true;
}

function check_for_attack_end(origin_unit, ds_attack_effect_objects){
	var attack_effects_done = true;
	for(var i=0; i<ds_list_size(ds_attack_effect_objects); i++){
		attack_effects_done = attack_effects_done and ds_attack_effect_objects[| i].done
	}
	var origin_unit_done = origin_unit.current_state != UNIT_STATES.attacking
	return attack_effects_done and origin_unit_done

}

function resolve_attack_hit_effect(attack_profile, attacker, defender){
	//Gather derived stats
	//Todo: placeholder for calculating boon, bane, terrain and weather info
	var hit_rate = max(attack_profile.base_accuracy - defender.unit_profile.base_avoid, 0)
	var damage = max(attack_profile.base_damage - max(defender.unit_profile.base_armour - attack_profile.base_piercing, 0), 0)
	//make the hit roll
	var hit_roll = irandom(100);
	var is_hit = hit_roll <= hit_rate;
	//apply damage and play hit/miss animation
	if (is_hit){
		//Hit
		defender.current_hp -= damage
		var floating_damage = instance_create_layer(defender.x,defender.y,"UI", obj_floating_damage_message)
		with(floating_damage){
			self.message_text = string(damage)
		}
		
		if(defender.current_hp >= 0){
			with(defender){
				sprite_index = animation_sprites[UNIT_STATES.hurt]
				image_index = 0
				current_state = UNIT_STATES.hurt
			}
		}else{
			with(defender){
				sprite_index = animation_sprites[UNIT_STATES.dying]
				image_index = 0
				current_state = UNIT_STATES.dying
			}
		}
	
	}else{
		//Miss
		var floating_miss = instance_create_layer(defender.x,defender.y,"UI", obj_floating_miss_message)
	}


}