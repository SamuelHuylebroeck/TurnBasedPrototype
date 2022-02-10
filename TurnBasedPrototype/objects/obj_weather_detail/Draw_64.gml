/// @description ??
if(global.map_running){
	
	var scale = global.ui_scale_values[global.current_ui_scale][0]
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	
	var margin = base_margin * scale
	
	#region text setting
	
	var weather_name_text = "Clear";
	var weather_descripton_array = ["No Effect"]
	
	var weather_under_cursor = instance_position(mouse_x, mouse_y, par_weather)
	if weather_under_cursor != noone {
		weather_name_text = weather_under_cursor.weather_name
		weather_descripton_array = weather_under_cursor.weather_description
	}
	#endregion
	
	#region width and heigth calculation
	var max_text_line_width = 0
	draw_set_font(fonts[1]);
	var current_height=2*frame_margin+string_height(weather_name_text);
	
	//Assumption: The title is never going to be the largest, skip calculating its width to keep code simpler
	draw_set_font(fonts[0]);
	var i = 0; repeat(array_length(weather_descripton_array))
	{

		var line = weather_descripton_array[i]
		var lw = string_width(line)
		if lw > max_text_line_width
		{
			max_text_line_width = lw
		}
		current_height += string_height(line)
		
	}
	
	
	var w = clamp(max_text_line_width + 2*frame_margin,base_width*scale, max_gui_width * display_get_gui_width() - 2* margin)
	var h = clamp(current_height, base_height * scale, max_gui_heigth * display_get_gui_height() - 2*margin)
	#endregion
	
	
	var current_pos_x = 0.25*display_get_gui_width();
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
	draw_text(current_pos_x,current_pos_y,weather_name_text);
	current_pos_y += string_height(weather_name_text)
	draw_set_font(fonts[0]);
	for(var i = 0; i< array_length(weather_descripton_array);i++){
		draw_text(current_pos_x,current_pos_y,weather_descripton_array[i]);
		current_pos_y += string_height(weather_descripton_array[i])
	}
	
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}