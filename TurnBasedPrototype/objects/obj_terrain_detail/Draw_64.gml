/// @description ??
if(global.map_running)
{
	var scale = global.ui_scale_values[global.current_ui_scale][0]
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var margin = base_margin * scale
	
	var icon_width = sprite_get_width(spr_stats_icon_armour)
	var icon_height = sprite_get_height(spr_stats_icon_armour)
	
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
	
	var terrain_foot_cost = -1;
	var terrain_heavy_cost = -1;
	var terrain_flying_cost = -1;
	
	var pathfinding_tile_under_cursor = instance_position(mouse_x, mouse_y, par_pathfinding_tile)
	if pathfinding_tile_under_cursor != noone {
		var terrain_foot_cost = pathfinding_tile_under_cursor.tile_costs[MOVEMENT_TYPES.foot];
		var terrain_heavy_cost = pathfinding_tile_under_cursor.tile_costs[MOVEMENT_TYPES.heavy];
		var terrain_flying_cost = pathfinding_tile_under_cursor.tile_costs[MOVEMENT_TYPES.flying];
	}
	
	
	var tile_position = get_tile_position(mouse_x, mouse_y)
	var position_text=string(tile_position[0])+","+string(tile_position[1])
	
	#endregion
	
	
	#region width and heigth calculation
	var max_text_line_width = 0
	var current_height=frame_margin;
	
	draw_set_font(fonts[1]);
	current_height += string_height(terrain_name_text);
	var lw = string_width(terrain_name_text)
	if lw > max_text_line_width
	{
		max_text_line_width = lw
	}
	
	current_height += 2.5* sprite_get_height(spr_stats_icon_armour);
	
	lw = 6*sprite_get_width(spr_stats_icon_armour);
	if lw > max_text_line_width
	{
		max_text_line_width = lw
	}
	
	draw_set_font(fonts[0]);
	current_height += string_height(position_text)
	lw = string_width(position_text)
	if lw > max_text_line_width
	{
		max_text_line_width = lw
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
	var old_valign = draw_get_valign();
	draw_set_halign(fa_left);

	draw_set_font(fonts[1]);
	draw_set_color(text_color);
	
	current_pos_x += frame_margin
	current_pos_y += frame_margin
	draw_text(current_pos_x,current_pos_y,terrain_name_text);
	current_pos_y += string_height(terrain_name_text)
	
	draw_set_font(fonts[0]);
	draw_set_valign(fa_middle)
	
	current_pos_y += icon_height/2
	draw_sprite(spr_stats_icon_armour,0, current_pos_x,current_pos_y);
	draw_text(current_pos_x + sprite_get_width(spr_stats_icon_armour), current_pos_y, ": "+string(terrain_armour_modifier))
	draw_sprite(spr_stats_icon_avoid,0, current_pos_x+2*+ sprite_get_width(spr_stats_icon_armour),current_pos_y);
	draw_text(current_pos_x + 3*+ sprite_get_width(spr_stats_icon_armour) , current_pos_y, ": " +string(terrain_avoid_modifier))
	current_pos_y += max(string_height(string(terrain_armour_modifier)), sprite_get_height(spr_stats_icon_armour))
	
	
	var move_cost_string = ": " + (terrain_foot_cost > 0 ? string(terrain_foot_cost) : "-")
	draw_sprite(spr_stats_icon_movement_foot,0, current_pos_x,current_pos_y);
	draw_text(current_pos_x + sprite_get_width(spr_stats_icon_armour), current_pos_y,move_cost_string)
	
	move_cost_string = ": " +(terrain_heavy_cost > 0 ? string(terrain_heavy_cost) : "-")
	draw_sprite(spr_stats_icon_movement_heavy,0, current_pos_x+2*+ sprite_get_width(spr_stats_icon_armour),current_pos_y);
	draw_text(current_pos_x + 3*+ sprite_get_width(spr_stats_icon_armour) , current_pos_y, move_cost_string)
	
	move_cost_string = ": " +(terrain_flying_cost > 0 ? string(terrain_flying_cost) : "-")
	draw_sprite(spr_stats_icon_movement_flying,0, current_pos_x+4*+ sprite_get_width(spr_stats_icon_armour),current_pos_y);
	draw_text(current_pos_x + 5*+ sprite_get_width(spr_stats_icon_armour) , current_pos_y, move_cost_string)
	current_pos_y += max(string_height(string(terrain_armour_modifier)), sprite_get_height(spr_stats_icon_armour))

	
	draw_text(current_pos_x,current_pos_y, position_text);
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
	draw_set_valign(old_valign);
}