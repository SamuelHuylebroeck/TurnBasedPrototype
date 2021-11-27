/// @description ??
if global.selected != noone and self.id == global.selected.id{
	global.selected = noone
}

if global.enemy_selected != noone and self.id == global.enemy_selected.id{
	global.enemy_selected = noone
}

ds_map_destroy(ds_terrain_crossed)
ds_map_destroy(ds_boons_and_banes)