/// @description ??
for (var i = 0; i< ds_list_size(ds_gui_elements);i++)
{
	var element = ds_gui_elements[| i];
	with(element)
	{
		instance_destroy();
	}
}
ds_list_destroy(ds_gui_elements);
ds_list_destroy(ds_turn_order)
audio_stop_all();