//@description ??
function draw_unit_stat_card(_x,_y, unit){
	
	var old_font = draw_get_font()
	var old_colour = draw_get_color()
	
	#region frame
	var current_pos_x = _x
	var current_pos_y= _y
	draw_sprite_stretched(spr_frame,0,current_pos_x,current_pos_y,frame_width,frame_heigth)
	#endregion frame
	
	current_pos_x += initial_internal_offset_x
	current_pos_y += initial_internal_offset_y
	
	var tl_anchor_x = current_pos_x
	var tl_anchor_y = current_pos_y
	
	#region unit stats
	current_pos_y = draw_unit_stats(current_pos_x, current_pos_y, unit)
	#endregion
	
	current_pos_x = tl_anchor_x
	current_pos_y += internal_offset_y *2
	
	draw_line(current_pos_x,current_pos_y, current_pos_x+(frame_width-2*(internal_offset_x+initial_internal_offset_x)), current_pos_y)

	#region attack stats
	
	current_pos_y = draw_attack_stats(current_pos_x, current_pos_y, unit.attack_profile)
	#endregion
	draw_line(current_pos_x,current_pos_y, current_pos_x+(frame_width-2*(internal_offset_x+initial_internal_offset_x)), current_pos_y)
	current_pos_y += internal_offset_y *2
	
	#region draw boon and bane info
	current_pos_y=draw_boon_and_bane(current_pos_x, current_pos_y, unit.ds_boons_and_banes)
	#endregion

}

function draw_unit_stats(_x, _y, unit){
	var current_pos_x = _x
	var current_pos_y = _y
	
	draw_set_alpha(1);
	
	draw_set_font(text_font);
	draw_set_color(text_colour);
	draw_text(current_pos_x,current_pos_y,unit.unit_profile.verbose_name);
	
	current_pos_y += string_height(unit.unit_profile.verbose_name) + internal_offset_y
	
	//HP and move
	var hp_line = "HP: " + string(unit.current_hp) + "/" + string(unit.unit_profile.max_hp)+" "
	var hp_line_width = string_width(hp_line);
	draw_text(current_pos_x,current_pos_y,hp_line);
	current_pos_x += (floor(hp_line_width/internal_offset_x)+1)*internal_offset_x
	var mov_line = "- MV: " + string(floor(unit.move_points_pixels_curr/global.grid_cell_width))+"/"+string(unit.unit_profile.base_movement)
	draw_text(current_pos_x,current_pos_y,mov_line);
	
	current_pos_x -= (floor(hp_line_width/internal_offset_x)+1)*internal_offset_x
	current_pos_y += string_height(hp_line) + internal_offset_y
	//Def and avoid
	var def_line = "ARM: " + string(unit.unit_profile.base_armour)
	var def_width = string_width(def_line);
	draw_text(current_pos_x,current_pos_y,def_line);
	current_pos_x += (floor(def_width/internal_offset_x)+1)*internal_offset_x
	var avo_line = "- AVO: " + string(unit.unit_profile.base_avoid)
	draw_text(current_pos_x,current_pos_y,avo_line);
	current_pos_y += string_height(avo_line) + internal_offset_y
	
	return current_pos_y
}
	
function draw_attack_stats(_x, _y, attack_profile){
		
	var current_pos_y = _y + internal_offset_y
	var damage_line ="Damage: " + string(attack_profile.base_damage)
	draw_text(_x,current_pos_y,damage_line);
	
	current_pos_y += string_height(damage_line) + internal_offset_y
	var piercing_line = "Piercing: " + string(attack_profile.base_piercing)
	draw_text(_x,current_pos_y,piercing_line);
	
	current_pos_y += string_height(piercing_line) + internal_offset_y
	var accuracy_line = "Accuracy: " + string(attack_profile.base_accuracy)
	draw_text(_x,current_pos_y,accuracy_line);
	
	current_pos_y += string_height(accuracy_line) + internal_offset_y
	var shapeline = "Shape: "+ get_shape_name(attack_profile)+ " ("+ string(attack_profile.base_size)+")"
	draw_text(_x,current_pos_y,shapeline);
	
	current_pos_y += string_height(shapeline)+internal_offset_y
	return current_pos_y

}

function get_shape_name(attack_profile){
	switch(attack_profile.base_shape){
		case ATTACK_SHAPES.as_line:
			return "Line"
		case ATTACK_SHAPES.as_cone:
			return "Cone"
		case ATTACK_SHAPES.as_blast:
			return "Blast"
		case ATTACK_SHAPES.as_wall:
			return "Wall"
		case ATTACK_SHAPES.as_burst:
			return "Burst"
		default:
			return "Not Found"
	
	}

}
	
function draw_boon_and_bane(_x,_y, ds_boons_and_banes){
	var boon_bane_icon_scale = 2
	var current_pos_x = _x
	var current_pos_y = _y
	if (ds_map_size(unit.ds_boons_and_banes) > 0)
	{
		var boons_and_banes = ds_map_values_to_array(unit.ds_boons_and_banes)
		var current_pos_x = _x
		var current_pos_y = _y
		for(var i = 0; i <array_length(boons_and_banes);i++){
			var icon_sprite = boons_and_banes[i].icon_sprite
			draw_sprite_ext(icon_sprite,0,current_pos_x, current_pos_y,boon_bane_icon_scale,boon_bane_icon_scale,0,c_white,1)
			current_pos_x += sprite_get_width(icon_sprite)*boon_bane_icon_scale
			if current_pos_x > _x+(frame_width-2*(internal_offset_x+initial_internal_offset_x)){
				current_pos_x = _x
				current_pos_y += sprite_get_width(icon_sprite)*boon_bane_icon_scale
			}
		
		}
	}
	return current_pos_y

}