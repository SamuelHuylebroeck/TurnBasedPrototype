/// @description ??
ds_active_units = ds_list_create();

player_current_resources = player_starting_resources

#region recruitment options
ds_recruitment_options = ds_list_create();
ds_list_copy(ds_recruitment_options, global.ds_basic_recruitment_options)
#endregion
