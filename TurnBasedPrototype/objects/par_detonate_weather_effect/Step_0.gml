/// @description ??
if not done and image_speed >0 {	
	if (not effect_applied and floor(image_index) == hit_frame){
		//Apply effect
		var defender = instance_position(x,y, par_abstract_unit)
		if (defender != noone){
			var explosion_damage = defender.unit_profile.max_hp*explosion_damage_rel_value
			do_hp_change(defender, -1*explosion_damage)
		}
		effect_applied = true
	}
	
	
	
	if (image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		instance_destroy()
	}
}