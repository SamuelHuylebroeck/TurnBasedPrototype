//@description ??
function draw_unit_stat_card(unit, max_width, max_height,padding_x, padding_y, text_colour){
	
	var old_font = draw_get_font()
	var old_colour = draw_get_color()
	var old_valign = draw_get_valign()
	
	draw_set_color(text_colour);
	
	var scale = global.ui_scale_values[global.current_ui_scale][0]
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var margin = base_margin * scale
	
	var separation_correction = 16
	
	#region height and width calculations
	var max_internal_width = 0
	var total_internal_height = 0 
	
	var unit_stat_dim = calculate_unit_stats_dimensions(unit, scale, fonts, padding_x, padding_y)
	var attack_stats_dim = calculate_attack_stats_dimensions(unit.attack_profile, scale, fonts, padding_x, padding_y)
	var weather_stats_dim = calculate_weather_stats_dimensions(unit.weather_profile, scale, fonts, padding_x, padding_y)
	
	max_internal_width = max(unit_stat_dim.mw, attack_stats_dim.mw)
	
	total_internal_height += unit_stat_dim.th + attack_stats_dim.th
	total_internal_height += calculate_boon_and_bane_height(unit.ds_boons_and_banes,scale, max_internal_width,padding_x, padding_y)
	
	
	var w = clamp(max_internal_width+initial_internal_offset_x, base_width*scale, max_width)
	var h = clamp(total_internal_height+initial_internal_offset_y+padding_y*4, base_height * scale, max_height)
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
	current_pos_y = draw_unit_stats(current_pos_x, current_pos_y,max_internal_width,unit_stat_dim.th, unit, scale, fonts,padding_x,padding_y)
	#endregion

	current_pos_x = tl_anchor_x
	
	draw_line(current_pos_x,current_pos_y-separation_correction, current_pos_x+(0.8*w), current_pos_y-separation_correction)
	current_pos_y += padding_y

	#region attack stats
	current_pos_y = draw_attack_stats(current_pos_x, current_pos_y, max_internal_width, attack_stats_dim.th, unit.attack_profile, scale, fonts, padding_x, padding_y)
	#endregion
	draw_line(current_pos_x,current_pos_y-separation_correction, current_pos_x+(0.8*w), current_pos_y-separation_correction)
	current_pos_y += padding_y
	
	#region weather stats
	current_pos_y = draw_weather_stats(current_pos_x, current_pos_y, max_internal_width, weather_stats_dim.th, unit.weather_profile, scale, fonts, padding_x, padding_y)
	#endregion
	draw_line(current_pos_x,current_pos_y-separation_correction, current_pos_x+(0.8*w), current_pos_y-separation_correction)
	current_pos_y += padding_y
	
	#region draw boon and bane info
	current_pos_y=draw_boon_and_bane(current_pos_x, current_pos_y,w, unit.ds_boons_and_banes)
	#endregion
	
	draw_set_font(old_font)
	draw_set_color(old_colour)
	draw_set_valign(old_valign)

}

function draw_unit_stats(_x, _y,width, height, unit, scale, fonts,padding_x,padding_y){
	var current_pos_x = _x
	var current_pos_y = _y
	
	var icon_width = sprite_get_width(spr_stats_icon_hp)
	var icon_height = sprite_get_height(spr_stats_icon_hp)
	
	draw_set_alpha(1);
	draw_set_font(fonts[1]);
	draw_text(current_pos_x,current_pos_y,unit.unit_profile.verbose_name);
	
	current_pos_y += max(string_height(unit.unit_profile.verbose_name), icon_height) + padding_y
	draw_set_font(fonts[0]);
	//HP and move
	draw_set_valign(fa_middle)
	current_pos_y += sprite_get_height(spr_stats_icon_hp)/2
	var hp_line =": "+string(unit.current_hp) + "/" + string(unit.unit_profile.max_hp)+" "
	var hp_line_width = string_width(hp_line);
	draw_sprite(spr_stats_icon_hp,0, current_pos_x, current_pos_y)
	current_pos_x += icon_width
	draw_text(current_pos_x,current_pos_y,hp_line);
	current_pos_x =_x+width/2
	draw_sprite(spr_stats_icon_movement,0, current_pos_x, current_pos_y)
	current_pos_x += icon_width
	var mov_line = ": "+string(floor(unit.move_points_pixels_curr/global.grid_cell_width))+"/"+string(unit.unit_profile.base_movement)
	draw_text(current_pos_x,current_pos_y,mov_line);
	
	current_pos_x = _x
	current_pos_y += max(string_height(hp_line),icon_height) + padding_y 
	//Def and avoid
	var def_line = ": "+string(unit.unit_profile.base_armour)
	var def_width = string_width(def_line);
	draw_sprite(spr_stats_icon_armour,0, current_pos_x, current_pos_y)
	current_pos_x += icon_width
	draw_text(current_pos_x,current_pos_y,def_line);
	current_pos_x = _x + width/2
	var avo_line = ": "+string(unit.unit_profile.base_avoid)
	draw_sprite(spr_stats_icon_avoid,0, current_pos_x, current_pos_y)
	current_pos_x += icon_width
	draw_text(current_pos_x,current_pos_y,avo_line);
	current_pos_y += max(icon_height,string_height(avo_line),string_height(def_line)) + padding_y
	
	return current_pos_y
}
function calculate_unit_stats_dimensions(unit, scale, fonts, padding_x, padding_y){
	var current_max_width = 0
	var total_height=0
	draw_set_font(fonts[1])
	
	var icon_width = sprite_get_width(spr_stats_icon_hp)
	var icon_height = sprite_get_height(spr_stats_icon_hp)
	
	var name_width = string_width(unit.unit_profile.verbose_name)
	
	total_height += string_height(unit.unit_profile.verbose_name)+padding_y
	
	//HP line is the longest
	draw_set_font(fonts[0])
	var hp_line = ": "+string(unit.current_hp) + "/" + string(unit.unit_profile.max_hp)+" "
	var hp_move_line_width = string_width(hp_line)+icon_width
	hp_move_line_width *=2
	total_height += 2* (max(string_height(hp_line),icon_height)+padding_y)
	
	current_max_width = max(name_width, hp_move_line_width)+2*padding_x
	
	return {
		mw: current_max_width,
		th: total_height
	}

}	
function draw_attack_stats(_x, _y,width, height, attack_profile, scale, fonts,padding_x,padding_y){
	
	draw_set_font(fonts[0])
	
	var icon_width = sprite_get_width(spr_stats_icon_damage)
	var icon_height= sprite_get_height(spr_stats_icon_damage)
	
	var current_pos_y = _y
	draw_sprite(spr_stats_icon_damage, 0, _x, current_pos_y)
	var damage_line =": " + string(attack_profile.base_damage)
	draw_text(_x+icon_width,current_pos_y,damage_line);
	
	draw_sprite(spr_stats_icon_piercing, 0, _x+width/2, current_pos_y)
	var piercing_line = ": " + string(attack_profile.base_piercing)
	draw_text(_x+width/2+icon_width,current_pos_y,piercing_line);
	
	current_pos_y += max(string_height(damage_line),string_height(piercing_line), icon_height) + padding_y
	
	draw_sprite(spr_stats_icon_accuracy, 0, _x, current_pos_y)
	var accuracy_line = ": " + string(attack_profile.base_accuracy)
	draw_text(_x+icon_width,current_pos_y,accuracy_line);
	
	draw_sprite(spr_stats_icon_range, 0, _x+width/2, current_pos_y)
	var range_line = ": "+ string(attack_profile.min_range) + "-"+ string(attack_profile.max_range)
	draw_text(_x+width/2+icon_width,current_pos_y,range_line);
	
	current_pos_y += max(string_height(accuracy_line), string_height(range_line), icon_height)+padding_y
	
	draw_sprite(get_shape_icon(attack_profile.base_shape),0, _x, current_pos_y)
	var shapeline = ": "+string(attack_profile.base_size)
	draw_text(_x+icon_width,current_pos_y,shapeline);
	
	current_pos_y += max(string_height(shapeline), icon_height)+padding_y
	return current_pos_y

}	
function calculate_attack_stats_dimensions(attack_profile, scale, fonts, padding_x, padding_y)
{
	var current_max_width = 0
	var total_height=0
	
	var icon_width= sprite_get_width(spr_stats_icon_damage);
	var icon_height= sprite_get_height(spr_stats_icon_damage);
	draw_set_font(fonts[0])
	var total_height = padding_y;
	var damage_line =": " + string(attack_profile.base_damage)
	
	total_height += max(icon_height, string_height(damage_line)) + padding_y
	var piercing_line = ": " + string(attack_profile.base_piercing)
	
	total_height += max(icon_height, string_height(piercing_line)) + padding_y
	var accuracy_line = ": " + string(attack_profile.base_accuracy)
	
	total_height += max(icon_height, string_height(accuracy_line)) + padding_y
	var shapeline = ": "+ string(attack_profile.base_size)
	
	total_height += max(icon_height, string_height(shapeline))+padding_y
	var range_line = ": "+ string(attack_profile.min_range) + "-"+ string(attack_profile.max_range)
	
	total_height += max(icon_height, string_height(range_line))+padding_y
	
	var current_max_string_width = max(
		string_width(damage_line),
		string_width(piercing_line),
		string_width(accuracy_line),
		string_width(piercing_line),
		string_width(shapeline),
		string_width(range_line)
	);
	return {
		mw: current_max_string_width+2*icon_width+2*padding_x,
		th: total_height
	}

}
function draw_weather_stats(_x, _y,width, height, weather_profile, scale, fonts,padding_x,padding_y){
	
	draw_set_font(fonts[0])
	
	var icon_width = sprite_get_width(spr_stats_icon_damage)
	var icon_height= sprite_get_height(spr_stats_icon_damage)
	
	var current_pos_y = _y
	draw_sprite(get_element_icon(weather_profile.weather_element), 0, _x, current_pos_y)
	var name_line =": " + string(weather_profile.verbose_name)
	draw_text(_x+icon_width,current_pos_y,name_line);
	
	current_pos_y += max(string_height(name_line), icon_height) + padding_y
	
	draw_sprite(spr_stats_icon_duration, 0, _x, current_pos_y)
	var duration_line = ": " + string(weather_profile.weather_duration)
	draw_text(_x+icon_width,current_pos_y,duration_line);
	
	draw_sprite(spr_stats_icon_shape_burst, 0, _x+width/2, current_pos_y)
	var burst_line = ": " + string(weather_profile.weather_burst_size)
	draw_text(_x+width/2+icon_width,current_pos_y,burst_line);
	
	current_pos_y += max(string_height(duration_line),string_height(burst_line), icon_height) + padding_y
	
	return current_pos_y

}	
function calculate_weather_stats_dimensions(weather_profile, scale, fonts, padding_x, padding_y)
{
	var current_max_width = 0
	var total_height=0
	
	var icon_width= sprite_get_width(spr_stats_icon_damage);
	var icon_height= sprite_get_height(spr_stats_icon_damage);
	
	draw_set_font(fonts[0])
	
	var total_height = padding_y;
	var name_line = ": "+string(weather_profile.verbose_name)
	var name_line_width = string_width(name_line) + icon_width
	
	total_height += max(icon_height, string_height(name_line)) + padding_y
	
	var duration_line=": " + string( weather_profile.weather_duration)
	var burst_size_line = ": "+string(weather_profile.weather_burst_size)
	var stats_line_width = max(string_width(duration_line), string_width(burst_size_line))+2*icon_width
	total_height += max(icon_height, string_height(duration_line),string_height(burst_size_line)) + padding_y

	return {
		mw: max(name_line_width,stats_line_width) + 2*padding_x,
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