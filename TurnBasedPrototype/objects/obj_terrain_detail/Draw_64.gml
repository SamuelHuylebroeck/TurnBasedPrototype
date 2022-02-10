/// @description ??
if(global.map_running)
{
	var scale = global.ui_scale_values[global.current_ui_scale][0]
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var margin = base_margin * scale
	
	#region text setting
	var terrain_name_text = "-";
	var terrain_armour_modifier = 0
	var terrain_avoid_modifier = 0
	
	var terrain_under_cursor = instance_position(mouse_x, mouse_y, par_terrain)
	if terrain_under_cursor != noone {
		terrain_name_text = terrain_under_cursor.terrain_name
		terrain_armour_modifier = terrain_under_cursor.armour_modifier
		terrain_avoid_modifier = terrain_under_cursor.avoid_modifier
	}
	
	var arm_text = "ARM: "+ string(terrain_armour_modifier)
	var avoid_text = "AVO: " + string(terrain_avoid_modifier)
	var position_text=string(floor(mouse_x/global.grid_cell_width))+","+string(floor(mouse_y/global.grid_cell_height))
	var text_lines = [terrain_name_text, arm_text, avoid_text, position_text]
	
	#endregion
	
	
	#region width and heigth calculation
	var max_text_line_width = 0
	var current_height=frame_margin;
	var i = 0; repeat(array_length(text_lines))
	{
		draw_set_font(i==0 ? fonts[1] : fonts[0]);
		var line = text_lines[i]
		var lw = string_width(line)
		if lw > max_text_line_width
		{
			max_text_line_width = lw
		}
		current_height += string_height(line)
		
	}
	
	
	var w = clamp( max_text_line_width + 2*frame_margin,base_width*scale, max_gui_width * display_get_gui_width() - 2* margin)
	var h = clamp(current_height, base_height * scale, max_gui_heigth * display_get_gui_height() - 2*margin)
	
	#endregion
	
	var current_pos_x = margin;
	var current_pos_y = display_get_gui_height()-h-margin;
	
	draw_sprite_stretched(spr_frame,0,current_pos_x,current_pos_y,w,h)

	var old_align = draw_get_halign();
	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_left);
	draw_set_font(fonts[1]);
	draw_set_color(text_color);
	
	current_pos_x += frame_margin
	current_pos_y += frame_margin
	draw_text(current_pos_x,current_pos_y,terrain_name_text);
	current_pos_y += string_height(terrain_name_text)
	
	draw_set_font(fonts[0]);
	

	draw_text(current_pos_x,current_pos_y, arm_text);
	current_pos_y += string_height(terrain_armour_modifier)

	var avoid_text = "AVO: " + string(terrain_avoid_modifier)
	draw_text(current_pos_x,current_pos_y, avoid_text);
	current_pos_y += string_height(avoid_text)
	
	
	draw_text(current_pos_x,current_pos_y, position_text);
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}