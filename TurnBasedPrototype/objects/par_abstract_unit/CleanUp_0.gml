/// @description ??
if global.debug_ai show_debug_message("Cleaning up Unit " + string(self.id))
if global.selected != noone and self.id == global.selected.id{
	global.selected = noone
}

if global.enemy_selected != noone and self.id == global.enemy_selected.id{
	global.enemy_selected = noone
}

ds_map_destroy(ds_terrain_crossed)
ds_map_destroy(ds_weather_crossed)
ds_map_destroy(ds_boons_and_banes)

if linked_taskforce != noone and ds_exists(linked_taskforce.ds_list_taskforce_units, ds_type_list) {
	//Delete from list
	var pos = ds_list_find_index(linked_taskforce.ds_list_taskforce_units, self.id)
	ds_list_delete(linked_taskforce.ds_list_taskforce_units, pos)
}

