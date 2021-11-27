
function do_hp_change(unit, hp_change){
		//Hit
		unit.current_hp += hp_change
		unit.current_hp = clamp(unit.current_hp, -1, unit.unit_profile.max_hp)
		var floating_damage = instance_create_layer(unit.x,unit.y,"UI", obj_floating_hp_change_message)
		with(floating_damage){
			self.message_text = string(abs(hp_change))
			self.hp_change = hp_change
		}
		
		if(unit.current_hp > 0 and hp_change < 0 and unit.current_state == UNIT_STATES.idle){
			with(unit){
				sprite_index = animation_sprites[UNIT_STATES.hurt]
				image_index = 0
				current_state = UNIT_STATES.hurt
				
			}
		}else{
			if(unit.current_hp <= 0 and hp_change < 0){
				with(unit){
					sprite_index = animation_sprites[UNIT_STATES.dying]
					image_index = 0
					current_state = UNIT_STATES.dying
				}
			}
		}


}