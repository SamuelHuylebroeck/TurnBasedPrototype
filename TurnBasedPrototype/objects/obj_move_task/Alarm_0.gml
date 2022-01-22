/// @description ??
event_inherited()
if global.debug_ai_execution show_debug_message("Executing move task: ["+string(floor(unit.x/global.grid_cell_width))+","+string(floor(unit.y/global.grid_cell_width))+"]->["+string(floor(target_x/global.grid_cell_width))+","+string(floor(target_y/global.grid_cell_height))+"]")
mp_grid_clear_all(global.map_grid)
add_impassible_tiles_to_grid(unit, true, false)
navigate(unit, unit.x,unit.y,target_x,target_y)
//var path_length = path_get_length(unit.path_index)
//traversal_time = path_length/global.path_move_speed * game_get_speed(gamespeed_fps)-0.05
traversal_time=0.8
alarm[1] = 0.2*game_get_speed(gamespeed_fps)
pan_camera_to_center_on_position(unit.x,unit.y,0.2)