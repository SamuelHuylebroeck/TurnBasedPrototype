function create_attack_targets(center_x, center_y, attack_profile, active_player){
	for(var i=-attack_profile.max_range;i<=attack_profile.max_range;i++){
		for(var j=-attack_profile.max_range;j<=attack_profile.max_range;j++){
			var manhattan_distance = abs(i) + abs(j)
			if (manhattan_distance >= attack_profile.min_range and manhattan_distance <= attack_profile.max_range){
				var unit_on_target = instance_position(center_x+i*global.grid_cell_width, center_y+j*global.grid_cell_height,par_abstract_unit)
				if(unit_on_target and not is_unit_friendly(unit_on_target, active_player)){
					//Only create an attack interaction square a single time
					if(!instance_position(center_x+i*global.grid_cell_width, center_y+j*global.grid_cell_height,obj_move_attack_possible)){
						var attack_pos_instance = instance_create_layer(center_x+(i-1/2)*global.grid_cell_width, center_y+(j-1/2)*global.grid_cell_height,"Pathing",obj_move_attack_possible)
						with(attack_pos_instance){
							linked_attack_profile = attack_profile
							alarm[0]=1
						}
					}
				}
			}
		}
	}
}

function create_attack_icons(origin_unit, attack_profile){
	var center = get_center_of_occupied_tile(self)
	var center_x = center[0]
	var center_y = center[1]
	//Check if in range
	var manhattan_distance = abs(floor(x/global.grid_cell_width) - floor(origin_unit.x/global.grid_cell_width)) + abs(floor(y/global.grid_cell_height) - floor(origin_unit.y/global.grid_cell_height))
	if(manhattan_distance >= attack_profile.min_range and manhattan_distance <= attack_profile.max_range){
		var instance = instance_create_layer(center_x, center_y,"UI",obj_placeholder_attack_command)
		with(instance){
			linked_attack_profile = attack_profile
			linked_attacker = origin_unit
		}
	}


}
	
function create_attack_preview(origin_unit, attack_profile){
	var targets
	//switch based on shape
	switch (attack_profile.base_shape){
		case ATTACK_SHAPES.as_blast:
			targets = get_attack_blast_target_positions(x,y,origin_unit, attack_profile)
			break;
		case ATTACK_SHAPES.as_burst:
			targets = get_attack_burst_target_positions(origin_unit.x,origin_unit.y,x,y,origin_unit, attack_profile)
			break;
		case ATTACK_SHAPES.as_cone:
			targets = get_attack_cone_target_positions(origin_unit.x, origin_unit.y,x,y,origin_unit, attack_profile)
			break;
		case ATTACK_SHAPES.as_line:
		default:
			targets = get_attack_line_target_positions(origin_unit.x, origin_unit.y,x,y,origin_unit, attack_profile)
	}
	create_attack_preview_targets(origin_unit, attack_profile, targets)
	
}


function create_attack_preview_targets(origin_unit, attack_profile, targets){
	for(var i=0; i< ds_list_size(targets);i++){
		var target_pos = targets[| i]
		var preview = instance_create_layer(target_pos._x, target_pos._y, "UI", obj_attack_preview)
		with(preview){
			linked_attack_profile = attack_profile
			linked_attacker = origin_unit
		}
	}
	ds_list_destroy(targets)
}

function clean_up_attack_preview(){
	with(obj_attack_preview){
		instance_destroy()
	}

}	
	
function start_attack(origin_unit, attack_profile){
	//Turn off player control
	global.player_permission_execute_orders = false
	//Clean up pathing information
	clean_possible_moves()
	//Setup the animation for the attacking unit
	with(origin_unit){
		image_index = 0
		sprite_index = animation_sprites[UNIT_STATES.attacking]
		current_state = UNIT_STATES.attacking
	}
	//Create the hit effect tiles
	create_attack_effect_objects(ds_attack_effect_objects,origin_unit, attack_profile);
	
	//Sfx
	play_sound(attack_profile.animation_profile.attack_sfx)
}


function attack_get_allowed_enemy_targets(center_x, center_y,origin_unit, attack_profile){
	var allowed_targets = ds_queue_create()
	for(var i=-attack_profile.max_range;i<=attack_profile.max_range;i++)
	{
		for(var j=-attack_profile.max_range;j<=attack_profile.max_range;j++)
		{
			var manhattan_distance = abs(i) + abs(j)
			if (manhattan_distance >= attack_profile.min_range and manhattan_distance <= attack_profile.max_range)
			{
				var unit_on_target = instance_position(center_x+i*global.grid_cell_width, center_y+j*global.grid_cell_height,par_abstract_unit)
				if unit_on_target != noone 
				{
					if (not is_unit_friendly(unit_on_target, origin_unit.controlling_player)) and unit_on_target.current_state != UNIT_STATES.dying
					{
						ds_queue_enqueue(allowed_targets, unit_on_target.id)
					}
				}

			}
		}
	}
	return allowed_targets
}

function is_unit_friendly(unit, player){
	if unit.controlling_player == noone or player == noone{
		return false 
	}
	return unit.controlling_player.id == player.id

}