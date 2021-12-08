//@description ??
function recreate_pathfinding_grid(){
	global.map_grid = mp_grid_create(global.grid_left_startpos,global.grid_top_startpos,
						global.grid_nr_h_cells, global.grid_nr_v_cells,
						global.grid_cell_width,global.grid_cell_height);
	global.navigate = path_add();
}

function destroy_pathfinding_grid(){
	path_delete(global.navigate);
	mp_grid_destroy(global.map_grid);
}