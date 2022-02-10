//@description ??
function draw_unit_stat_card(unit){
	
	var old_font = draw_get_font()
	var old_colour = draw_get_color()
	
	var scale = global.ui_scale_values[global.current_ui_scale][0]
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var margin = base_margin * scale
	
	#region height and width calculations
	var max_internal_width = 0
	var total_internal_height = 0 
	
	var unit_stat_dim = calculate_unit_stats_dimensions(unit, scale, fonts, internal_offset_x, internal_offset_y)
	var attack_stats_dim = calculate_attack_stats_dimensions(unit.attack_profile, scale, fonts, internal_offset_x, internal_offset_y)
	max_internal_width = max(unit_stat_dim.mw, attack_stats_dim.mw)
	
	total_internal_height += unit_stat_dim.th + attack_stats_dim.th
	total_internal_height += calculate_boon_and_bane_height(unit.ds_boons_and_banes,scale, max_internal_width,internal_offset_x, internal_offset_y)
	
	
	var w = clamp(max_internal_width+initial_internal_offset_x, base_width*scale, max_gui_width*display_get_gui_width())
	var h = clamp(total_internal_height+initial_internal_offset_y+internal_offset_y*4, base_height * scale, max_gui_heigth*display_get_gui_width())
	#endregion
	
	
	#region draw frame
	var current_pos_x = left_side ? margin : display_get_gui_width()-w-margin
	var current_pos_y= margin
	draw_sprite_stretched(spr_frame,0,current_pos_x,current_pos_y,w,h)
	#endregion frame
	
	current_pos_x += initial_internal_offset_x
	current_pos_y += initial_internal_offset_y
	
	var tl_anchor_x = current_pos_x
	var tl_anchor_y = current_pos_y
	
	#region unit stats
	current_pos_y = draw_unit_stats(current_pos_x, current_pos_y, unit, scale, fonts)
	#endregion
	
	current_pos_x = tl_anchor_x
	current_pos_y += internal_offset_y *2
	
	draw_line(current_pos_x,current_pos_y, current_pos_x+(0.8*w), current_pos_y)

	#region attack stats
	
	current_pos_y = draw_attack_stats(current_pos_x, current_pos_y, unit.attack_profile, scale, fonts)
	#endregion
	draw_line(current_pos_x,current_pos_y, current_pos_x+(0.8*w), current_pos_y)
	current_pos_y += internal_offset_y *2
	
	#region draw boon and bane info
	current_pos_y=draw_boon_and_bane(current_pos_x, current_pos_y,w, unit.ds_boons_and_banes)
	#endregion
	
	draw_set_font(old_font)
	draw_set_color(old_colour)

}

function draw_unit_stats(_x, _y, unit, scale, fonts){
	var current_pos_x = _x
	var current_pos_y = _y
	
	draw_set_alpha(1);
	
	draw_set_font(fonts[1]);
	draw_set_color(text_colour);
	draw_text(current_pos_x,current_pos_y,unit.unit_profile.verbose_name);
	
	current_pos_y += string_height(unit.unit_profile.verbose_name) + internal_offset_y
	draw_set_font(fonts[0]);
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
function calculate_unit_stats_dimensions(unit, scale, fonts, internal_offset_x, internal_offset_y){
	var current_max_width = 0
	var total_height=0
	draw_set_font(fonts[1])
	
	var name_width = string_width(unit.unit_profile.verbose_name)
	total_height += string_height(unit.unit_profile.verbose_name)+internal_offset_y
	
	//HP and move
	draw_set_font(fonts[0])
	var hp_line = "HP: " + string(unit.current_hp) + "/" + string(unit.unit_profile.max_hp)+" "
	var hp_move_line_width = string_width(hp_line)
	var hp_move_line_width = hp_move_line_width + (floor(hp_move_line_width/internal_offset_x)+1)*internal_offset_x;
	var mov_line = "- MV: " + string(floor(unit.move_points_pixels_curr/global.grid_cell_width))+"/"+string(unit.unit_profile.base_movement)
	
	hp_move_line_width += string_width(mov_line)
	total_height += max(string_height(hp_line), string_height(mov_line)) + internal_offset_y
	//Def and avoid
	var def_line = "ARM: " + string(unit.unit_profile.base_armour)
	var def_and_avoid_width = string_width(def_line);
	def_and_avoid_width += (floor(def_and_avoid_width/internal_offset_x)+1)*internal_offset_x
	var avo_line = "- AVO: " + string(unit.unit_profile.base_avoid)
	def_and_avoid_width += string_width(avo_line)
	
	total_height += string_height(avo_line) + internal_offset_y
	current_max_width = max(name_width, hp_move_line_width, def_and_avoid_width)
	
	return {
		mw: current_max_width,
		th: total_height
	}

}	
function draw_attack_stats(_x, _y, attack_profile, scale, fonts){
	
	draw_set_font(fonts[0])
	
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
	var range_line = "Range: "+ string(attack_profile.min_range) + "-"+ string(attack_profile.max_range)
	draw_text(_x,current_pos_y,range_line);
	
	current_pos_y += string_height(range_line)+internal_offset_y
	return current_pos_y

}
	
	
function calculate_attack_stats_dimensions(attack_profile, scale, fonts, internal_offset_x, internal_offset_y)
{
	var current_max_width = 0
	var total_height=0
	
	var total_height = internal_offset_y
	var damage_line ="Damage: " + string(attack_profile.base_damage)
	
	total_height += string_height(damage_line) + internal_offset_y
	var piercing_line = "Piercing: " + string(attack_profile.base_piercing)
	
	total_height += string_height(piercing_line) + internal_offset_y
	var accuracy_line = "Accuracy: " + string(attack_profile.base_accuracy)
	
	total_height += string_height(accuracy_line) + internal_offset_y
	var shapeline = "Shape: "+ get_shape_name(attack_profile)+ " ("+ string(attack_profile.base_size)+")"
	
	total_height += string_height(shapeline)+internal_offset_y
	var range_line = "Range: "+ string(attack_profile.min_range) + "-"+ string(attack_profile.max_range)
	
	total_height += string_height(range_line)+internal_offset_y
	
	current_max_width = max(
		string_width(damage_line),
		string_width(piercing_line),
		string_width(accuracy_line),
		string_width(piercing_line),
		string_width(shapeline),
		string_width(range_line)
	);
	return {
		mw: current_max_width,
		th: total_height
	}

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
	
function draw_boon_and_bane(_x,_y, w, ds_boons_and_banes){
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
			if current_pos_x > _x+(0.8*w){
				current_pos_x = _x
				current_pos_y += sprite_get_width(icon_sprite)*boon_bane_icon_scale
			}
		
		}
	}
	return current_pos_y
}

function calculate_boon_and_bane_height(ds_boons_and_banes, scale, max_width, internal_offset_x, internal_offset_y){
	var boon_bane_icon_scale = 2
	var current_pos_x = 0
	var nr_rows = 0
	var max_icon_height = 0
	if (ds_map_size(ds_boons_and_banes) > 0)
	{
		nr_rows++
		var boons_and_banes = ds_map_values_to_array(ds_boons_and_banes)
		for(var i = 0; i <array_length(boons_and_banes);i++){
			var icon_sprite = boons_and_banes[i].icon_sprite
			current_pos_x += sprite_get_width(icon_sprite)*boon_bane_icon_scale*scale
			
			var icon_height = sprite_get_height(icon_sprite) * boon_bane_icon_scale * scale
			if icon_height > max_icon_height
			{
				max_icon_height = icon_height
			}
			
			
			if current_pos_x > (max_width-2*(internal_offset_x)){
				current_pos_x = 0
				nr_rows++
			}
		
		}
	}
	return nr_rows * max_icon_height + 2*internal_offset_y
}