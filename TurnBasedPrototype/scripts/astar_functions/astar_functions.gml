function get_astar_path(start_tile, destination_tile, movement_type)
{
	//Early exits
	//If destination is not walkable, exit with no path found
	if(destination_tile == noone)
	{
			return {
				path_found: false,
				movement_type: movement_type,
				path: [],
				cost: -1
			}
	}
	var grid_max_w = array_length(grid);
	var grid_max_h = array_length(grid[0]);
	var destination_tile_pos = get_tile_position(destination_tile.x, destination_tile.y);
	if(destination_tile_pos[0] <0 ||  destination_tile_pos[0] >= grid_max_w || destination_tile_pos[1] <0 ||  destination_tile_pos[1] >= grid_max_w
		|| not is_tile_walkable(destination_tile, movement_type))
	{
			return {
				path_found: false,
				movement_type: movement_type,
				path: [],
				cost: -1
			}
	}
	


	 if(start_tile == destination_tile)
	 {
		//If start and destination are the same, exit with simple path
		return {
			path_found: true,
			movement_type: movement_type,
			path: [destination_tile],
			cost: destination_tile.tile_costs[movement_type]
		}
	 }
	
	//Initialize data structures
	ds_priority_clear(open_list);
	ds_list_clear(closed_list);

	//Reset grid_state
	reset_grid()

	//Add the initial tile
	ds_priority_add(open_list, start_tile.id , 0);
	
	var start_tile_position = get_tile_position(start_tile.x, start_tile.y)
	var destination_tile_pos = get_tile_position(destination_tile.x, destination_tile.y);
	
	var path_found = false
	//Iterate
	while(ds_priority_size(open_list) > 0 && not path_found)
	{
		var to_expand = ds_priority_delete_min(open_list);
		var tile_position = get_tile_position(to_expand.x, to_expand.y)
		if(tile_position[0] == destination_tile_pos[0] and tile_position[1] == destination_tile_pos[1]){
			path_found = true;
			break;
		}
		ds_list_add(closed_list, to_expand.id);
		//Consider neighbours
		for(var i=-1; i<2;i++)
		{
			for(var j=-1;j<2;j++)
			{
				if(not(abs(i) == abs(j)))
				{
					//Call up neightbour candidate
					var candidate_x = tile_position[0] + i;
					var candidate_y = tile_position[1] + j;
					if(candidate_x < 0 
						or candidate_x >= grid_max_w 
						or candidate_y <0
						or candidate_y >= grid_max_h)
					{
						continue
					}
					var candidate = grid[candidate_x][candidate_y];
					
					if(not is_tile_walkable(candidate, movement_type))
					{
						continue;
					}
					
					if(ds_list_find_index(closed_list, candidate.id) != -1)
					{
						continue;
					}
					
					var current_f_cost = ds_priority_find_priority(open_list ,candidate.id)
					var heuristic =(destination_tile_pos[0] - candidate_x)*(destination_tile_pos[0] - candidate_x)+ (destination_tile_pos[1]-candidate_y)*(destination_tile_pos[1]-candidate_y)
				
					if(current_f_cost == undefined)
					{
						//If not present, update costs and add it to the open list
						candidate.g_cost = to_expand.g_cost + candidate.tile_costs[movement_type]
						candidate.h_cost = heuristic
						candidate.f_cost = candidate.g_cost + candidate.h_cost
						candidate.current_parent = to_expand.id;
						ds_priority_add(open_list,candidate.id, candidate.f_cost)
					}else{
						//If present, see if score needs to be updated
						var new_g_cost = to_expand.g_cost + candidate.tile_costs[movement_type]
						if(new_g_cost < candidate.g_cost)
						{
							//Better route found, update the node in the open list
							candidate.g_cost = to_expand.g_cost + candidate.tile_costs[movement_type]
							candidate.h_cost = heuristic
							candidate.f_cost = candidate.g_cost + candidate.h_cost
							candidate.current_parent = to_expand.id;
							ds_priority_change_priority(open_list, candidate.id, candidate.f_cost)
						}
					}		
				}
			}
		}
	
	}
	if(path_found)
	{
		//Reconstruct path
		var found_path = build_astar_path(destination_tile);
		return {
			path_found: true,
			movement_type: movement_type,
			path: found_path,
			cost: destination_tile.g_cost
		}
	} else
	{
		return {
			path_found: false,
			movement_type: movement_type,
			path: [],
			cost: -1
		}
	}
	
}

function is_tile_walkable(tile, movement_type)
{	
	var walkable = tile.tile_costs[movement_type] > 0;
	var occupied = is_tile_occupied(tile)
	return walkable and not occupied
}

function is_tile_occupied(tile)
{
	return position_meeting(tile.x + global.grid_cell_width/2, tile.y + global.grid_cell_height/2, par_abstract_unit)
}

function reset_grid()
{
	with(par_pathfinding_tile)
	{
		g_cost = 0;
		h_cost = -1;
		f_cost = -1;
		current_parent = noone;
	}
}

function build_grid(grid_width, grid_height)
{
	grid = array_create(grid_width)
	for(i = 0; i< grid_width; i++)
	{
		grid[i] = array_create(grid_height)
	}
	
	with(par_pathfinding_tile)
	{
		var tile_x = floor(x/global.grid_cell_width)
		var tile_y = floor(y/global.grid_cell_height)
		
		other.grid[tile_x][tile_y] = self;
	}
}

function build_astar_path(destination_tile)
{
	ds_stack_clear(path_stack)
	var parent = destination_tile.current_parent;
	
	ds_stack_push(path_stack, destination_tile);
	
	while(parent != noone)
	{
		ds_stack_push(path_stack, parent)
		parent = parent.current_parent;
	}
	
	var path_array = array_create(ds_stack_size(path_stack))
	var i=0;
	while(!ds_stack_empty(path_stack))
	{
		path_array[i] = ds_stack_pop(path_stack)
		i++;
	}
	return path_array;
}

function build_astar_path_object(path_tile_array, path_cost)
{
	//Create path object
	var path = instance_create_layer(0,0, "UI", obj_astarpath)
	with(path)
	{
		cost = path_cost;
		for(var i=0; i<array_length(path_tile_array);i++)
		{
			ds_list_add(ds_path_tiles, path_tile_array[i]);
		}
	}
	return path
}