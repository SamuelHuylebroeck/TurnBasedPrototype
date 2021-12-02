function is_mouse_hovering_over_gui_element(x_pos, y_pos, width, height) {
	var mouse_gui_x = device_mouse_x_to_gui(0);
	var mouse_gui_y = device_mouse_y_to_gui(0);
	
	return point_in_rectangle(mouse_gui_x,mouse_gui_y,x_pos,y_pos,x_pos+width,y_pos+height);
}

function is_mouse_hovering_over_rectangle(x_pos, y_pos, width, height){
	return point_in_rectangle(mouse_x,mouse_y,x_pos,y_pos,x_pos+width,y_pos+height);

}
