/// @description ??

// Inherit the parent event
event_inherited();

//Create options
options = array_create(array_length(global.all_player_type_options))
array_copy(options,0,global.all_player_type_options,0,array_length(global.all_player_type_options))
current_option = options[1]
