/// @description ??
if(global.map_running){
	
	var current_pos_x = margin;
	var current_pos_y = display_get_gui_height()-h-margin;
	
	draw_sprite_stretched(spr_next_turn_button,0,current_pos_x,current_pos_y,w,h)

	var old_align = draw_get_halign();
	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_left);
	draw_set_font(text_font);
	draw_set_color(text_color);
	
	var terrain_name_text = "-";
	var terrain_armour_modifier = 0
	var terrain_avoid_modifier = 0
	
	var terrain_under_cursor = instance_position(mouse_x, mouse_y, par_terrain)
	if terrain_under_cursor != noone {
		terrain_name_text = terrain_under_cursor.terrain_name
		terrain_armour_modifier = terrain_under_cursor.armour_modifier
		terrain_avoid_modifier = terrain_under_cursor.avoid_modifier
	}
	current_pos_x += frame_margin
	current_pos_y += frame_margin
	draw_text(current_pos_x,current_pos_y,terrain_name_text);

	current_pos_y += string_height(terrain_name_text)
	var arm_text = "ARM: "+ string(terrain_armour_modifier)

	draw_text(current_pos_x,current_pos_y, arm_text);
	current_pos_y += string_height(terrain_armour_modifier)

	var avoid_text = "AVO: " + string(terrain_avoid_modifier)
	draw_text(current_pos_x,current_pos_y, avoid_text);
	current_pos_y += string_height(avoid_text)
	
	var position_text=string(floor(mouse_x/global.grid_cell_width))+","+string(floor(mouse_y/global.grid_cell_height))
	draw_text(current_pos_x,current_pos_y, position_text);
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}