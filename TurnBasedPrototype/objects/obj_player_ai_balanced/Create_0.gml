/// @description ??

// Inherit the parent event
event_inherited();

#region task_force_composition
ds_map_add(ds_map_force_max_composition, obj_raider_taskforce,1)
ds_map_add(ds_map_force_max_composition, obj_assault_taskforce,0)
ds_map_add(ds_map_force_max_composition, obj_defender_taskforce,0)

//Always initialize current counts to 0 to let the creation process take over
ds_map_add(ds_map_force_current_composition, obj_raider_taskforce,0)
ds_map_add(ds_map_force_current_composition, obj_assault_taskforce,0)
ds_map_add(ds_map_force_current_composition, obj_defender_taskforce,0)
#endregion