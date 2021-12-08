/// @description ??

//Create player_composition data structure
ds_active_players = ds_list_create()

//Create add player_button
add_button = instance_create_layer(x+frame_inner_margin,y+frame_inner_margin+player_config_height,"Picker_Options", obj_add_player_button)
add_button.player_setup = self.id
// Create initial player
add_new_player(self.id)