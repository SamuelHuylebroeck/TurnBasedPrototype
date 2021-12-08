/// @description ??
ds_active_units = ds_list_create();

player_current_resources = player_starting_resources

#region recruitment options
ds_recruitment_options = ds_list_create();

var option_one = new recruitment_option("Placeholder 1", obj_placeholder_unit, 50)
ds_list_add(ds_recruitment_options, option_one)

var option_two = new recruitment_option("Placeholder 2", obj_placeholder_unit_alternate, 100)
ds_list_add(ds_recruitment_options, option_two)
#endregion
