/// @description ??
ds_recruitment_options = ds_map_create();
ds_tabs = ds_list_create();
ds_current_active_options = ds_list_create()

// Create cancel button
cancel_button = instance_create_layer(0, 0, "UI", obj_tabbed_recruitment_cancel)
// Create the recruit button
recruit_button = instance_create_layer(0, 0, "UI",  obj_tabbed_recruitment_recruit_button)
with(recruit_button)
{
	dialog = other;
	initialized = true;
}

initialized = false;
current_active_tab = 0;
current_active_option = -1;
current_preview = noone;

recruitment_building = noone;


