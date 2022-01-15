/// @description ??
if(global.map_running){
	
	var current_pos_x = display_get_gui_width()/2-w/2;
	var current_pos_y = display_get_gui_height()-h-margin;
	
	draw_sprite_stretched(spr_next_turn_button,0,current_pos_x,current_pos_y,w,h)

	var old_align = draw_get_halign();
	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_left);
	draw_set_font(font_stat_card_small);
	draw_set_color(text_color);
	
	var weather_name_text = "Clear";
	var weather_descripton_array = ["No Effect"]
	
	var weather_under_cursor = instance_position(mouse_x, mouse_y, par_weather)
	if weather_under_cursor != noone {
		weather_name_text = weather_under_cursor.weather_name
		weather_descripton_array = weather_under_cursor.weather_description
	}
	current_pos_x += frame_margin
	current_pos_y += frame_margin
	draw_text(current_pos_x,current_pos_y,weather_name_text);
	current_pos_y += string_height(weather_name_text)
	draw_set_font(font_attack_preview);
	for(var i = 0; i< array_length(weather_descripton_array);i++){
		draw_text(current_pos_x,current_pos_y,weather_descripton_array[i]);
		current_pos_y += string_height(weather_descripton_array[i])
	}
	
	draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_align);
}