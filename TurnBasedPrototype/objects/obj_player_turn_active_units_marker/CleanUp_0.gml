/// @description ??
var gui_element = self;
with(obj_control)
{
	if(ds_exists(ds_gui_elements, ds_type_list))
	{
		var pos = ds_list_find_index(ds_gui_elements, gui_element);
		ds_list_delete(ds_gui_elements, pos);
	}

}