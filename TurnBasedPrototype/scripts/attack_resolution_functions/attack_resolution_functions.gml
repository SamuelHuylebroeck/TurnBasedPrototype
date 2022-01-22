function create_attack_effect_objects(ds_attack_effect_objects, origin_unit, attack_profile){
	var targets = get_attack_target_tiles(origin_unit.x, origin_unit.y,x,y,origin_unit, attack_profile)
	for(var i=0; i< ds_list_size(targets);i++){
		var target_pos = targets[| i]
		create_attack_effect_object_at_location(i, target_pos._x, target_pos._y,  origin_unit, attack_profile);
		
	}
	ds_list_destroy(targets)
}

function get_attack_target_tiles(origin_x, origin_y, target_x, target_y, origin_unit, attack_profile){
	var target_tiles = ds_list_create();
	switch(attack_profile.base_shape){
		case ATTACK_SHAPES.as_blast:
			target_tiles = get_attack_blast_target_positions(target_x,target_y,origin_unit, attack_profile)
			break;
		case ATTACK_SHAPES.as_burst:
			target_tiles = get_attack_burst_target_positions(origin_x,origin_y, target_x, target_y, origin_unit, attack_profile)
			break;
		case ATTACK_SHAPES.as_cone:
			target_tiles = get_attack_cone_target_positions(origin_x, origin_y, target_x,target_y, origin_unit, attack_profile);
			break;
		case ATTACK_SHAPES.as_line:
		default:
			target_tiles = get_attack_line_target_positions(origin_x, origin_y, target_x,target_y, origin_unit, attack_profile);
	}
	return target_tiles

}

function create_attack_effect_object_at_location(i, _x, _y, origin_unit, attack_profile){
	var instance = instance_create_layer(_x, _y, "Weather", obj_placeholder_attack_hit_effect)
	with(instance){
		//Calculate when the attack should trigger
		var time_to_hit_frame = attack_profile.animation_profile.hit_frame * origin_unit.image_speed / attack_profile.animation_profile.base_sprite_animation_speed * game_get_speed(gamespeed_fps)
		hit_frame = attack_profile.animation_profile.hit_sprite_hit_frame
		alarm[0] = time_to_hit_frame
		// Set the required data
		sprite_index = attack_profile.animation_profile.hit_sprite
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
	var refined_profile = get_refined_stats(attack_profile, attacker, defender)
	
	var hit_rate = refined_profile.hr
	var damage = refined_profile.d
	//make the hit roll
	var hit_roll = irandom(100);
	var is_hit = hit_roll <= hit_rate;
	show_debug_message("From " + string(attacker.id)+" to " + string(defender.id))
	show_debug_message("Hit rate " +string(hit_rate) + " / Damage: " + string(damage) + " Roll: " + string(hit_roll))
	//apply damage and play hit/miss animation
	if (is_hit){
		//Hit
		do_hp_change(defender, -1* damage)
	}else{
		//Miss
		var floating_miss = instance_create_layer(defender.x,defender.y,"UI", obj_floating_miss_message)
	}


}
	
function get_refined_stats(attack_profile, attacker, defender){
	// Get the base rates
	var hit_rate = attack_profile.base_accuracy - defender.unit_profile.base_avoid
	var damage = attack_profile.base_damage
	var piercing = attack_profile.base_piercing
	var armour = defender.unit_profile.base_armour
	
	//Incorporate terrain information
	var occupied_terrain = instance_position( defender.x, defender.y, par_terrain );

	if (occupied_terrain != noone){
		hit_rate -= occupied_terrain.avoid_modifier
		armour += occupied_terrain.armour_modifier
	}
	
	//Incorporate boon and bane information of attacker
	
	//Incorporate boon and bane information of defender
	
	//Clamp to min and maxes and resolve piercing
	var hit_rate = max(hit_rate , 0)
	if (armour > 0)  {
		armour = max(armour - piercing ,0)
	}
	var damage = max(damage - armour, 0)
	return {
		hr: hit_rate,
		d: damage
	}

}