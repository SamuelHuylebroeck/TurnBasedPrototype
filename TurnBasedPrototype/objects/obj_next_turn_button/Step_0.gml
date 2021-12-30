/// @description ??
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
	with(obj_control){
		goto_next_turn();
	}
}