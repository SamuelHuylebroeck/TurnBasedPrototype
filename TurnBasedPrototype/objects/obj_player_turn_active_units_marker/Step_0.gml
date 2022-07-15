/// @description ??
var scale = global.ui_scale_values[global.current_ui_scale][0] * base_scale
var width = scale * base_width*base_scale;
var height = scale * base_height*base_scale;

var width = scale * base_width*base_scale;
var height = scale * base_height*base_scale;

var pos_x = rel_anchor_x * display_get_gui_width();
var pos_y = rel_anchor_y * display_get_gui_height();

var hover = is_mouse_hovering_over_gui_element(pos_x,pos_y,width,height);
var click = hover && mouse_check_button_pressed(mb_left)

if(hover && global.map_running)
{
	highlighted = true;
}else{
	highlighted = false;
}

if(visible && click && global.map_running && global.player_permission_click_next_turn)
{
	var current_index = ci.current_active_player_index % ds_list_size(ci.ds_turn_order)
	var player = ci.ds_turn_order[| current_index]
	
	with(obj_control){
		handle_select_next_available(player)
	}
}
