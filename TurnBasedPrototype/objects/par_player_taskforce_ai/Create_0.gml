/// @description ??
event_inherited()
ds_list_taskforces = ds_list_create()
ds_list_unit_reserves = ds_list_create()
ds_map_force_max_composition = ds_map_create()
ds_map_force_current_composition = ds_map_create()

#region recruitment matrices
configure_default_recruitment_stance_matrix()
configure_default_recruitment_type_matrix()
#endregion