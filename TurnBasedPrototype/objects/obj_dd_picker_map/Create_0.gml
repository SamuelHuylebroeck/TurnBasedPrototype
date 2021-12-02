/// @description ??

// Inherit the parent event
event_inherited();

//Create options
options = array_create(array_length(global.all_map_options))
array_copy(options,0,global.all_map_options,0,array_length(global.all_map_options))
current_option = options[0]
