/// @description ??
if(global.map_running){
	var fonts = global.ui_scale_values[global.current_ui_scale][2]
	var scale = global.ui_scale_values[global.current_ui_scale][0] * base_scale
	var width = scale * base_width*base_scale;
	var height = scale * base_height*base_scale;

	var pos_x = rel_anchor_x * display_get_gui_width();
	var pos_y = rel_anchor_y * display_get_gui_height();
	
	var current_index = ci.current_active_player_index % ds_list_size(ci.ds_turn_order)
	var player = ci.ds_turn_order[| current_index]
	var count=0;
	for(var i=0;i<ds_list_size(player.ds_active_units);i++)
	{
		var unit = player.ds_active_units[|i];
		if(unit != noone and instance_exists(unit) and !(unit.has_acted_this_round))
		{
			count++;
		}
	}
	

	if(highlighted && count >0)
	{
		draw_sprite_stretched(spr_button,1,pos_x,pos_y, width, height);
	}else
	{
		draw_sprite_stretched(spr_button,0,pos_x,pos_y, width, height);
	}

	#region player number

	var text_colour = highlighted&&count>0?c_soft_yellow:c_soft_yellow_dark;
	
	var old_halign = draw_get_halign();
	var old_valign = draw_get_halign();
	var old_font = draw_get_font();
	var old_color = draw_get_color();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle)
	draw_set_font(fonts[1]);
	draw_set_color(text_colour);
	
	draw_text(pos_x+width/2,pos_y+height/2, string(count));
	
	draw_set_halign(old_halign);
	draw_set_valign(old_valign)
	draw_set_font(old_font);
	draw_set_color(old_color);

	#endregion

}
