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
	
	#region attack stats
	
	current_pos_y = draw_attack_stats(current_pos_x, current_pos_y, unit.attack_profile)
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
	
	show_debug_message("Draw attack stats on card")

}