/// @description ??
ds_recruitment_options = ds_list_create()

top_corner = {
	_x: display_get_gui_width()/2,
	_y: display_get_gui_width()/2	
}
// Create cancel button
cancel_button = instance_create_layer(top_corner._x, top_corner._y, "UI", obj_recruitment_dialog_cancel)