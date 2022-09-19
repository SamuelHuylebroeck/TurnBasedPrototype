//@description ??
function draw_possible_moves_selected(){
	mp_grid_clear_all(global.map_grid);
	add_impassible_tiles_to_grid(global.selected,true, false)
		//Draw
	var center = get_center_of_occupied_tile(global.selected);
	var center_x = center[0];
	var center_y = center[1];
	var range = global.selected.move_points_current_total;
	var w = global.grid_cell_width;
	var h = global.grid_cell_height
	for(var i=-range; i<=range; i+=1){
		var i_x = i * w + center_x;
		for(var j=-range;j<=range;j++){
			var i_y = j* h + center_y;
			//check for move
			if(mp_grid_path(global.map_grid,global.navigate,center_x,center_y, i_x,i_y, global.path_allow_diag)){
				if (path_get_length(global.navigate) <= global.selected.move_points_pixels_curr)
				{
					//Check if this space is occupied
					if(!position_meeting(i_x,i_y, par_abstract_unit))
					{
						move_possible = instance_create_layer(i_x - w/2,i_y - h/2 ,"Pathing", obj_move_possible);
						with(move_possible){
							linked_attack_profile = global.selected.attack_profile;
							linked_player = global.selected.controlling_player;
							alarm[0]=1
						}
						
						
						//AStar debugging
						if(global.pathfinder != noone)
						{
							//Find path
							var astar_path_result;
							with(global.pathfinder)
							{
								var start_tile = instance_position(center_x, center_y, par_pathfinding_tile);
								var destination_tile = instance_position(i_x, i_y, par_pathfinding_tile);
								astar_path_result = get_astar_path(start_tile, destination_tile, MOVEMENT_TYPES.foot)
							}
							//Create path object
							if(astar_path_result.path_found)
							{
								var path = instance_create_layer(0,0, "UI", obj_astarpath)
								with(path)
								{
									cost = astar_path_result.cost;
									for(var k=0; k<array_length(astar_path_result.path);k++)
									{
										ds_list_add(ds_path_tiles, astar_path_result.path[k]);
									}
								}
								//Link to movement object
								with(move_possible)
								{
									astar_path = path;
								}
							}

						}

					}
				}else{
					instance_create_layer(i_x - w/2,i_y-h/2,"Pathing", obj_move_impossible);
				}
			}
		
		}
	}
	//Add possible attacks from current position
	create_attack_targets(global.selected.x, global.selected.y, global.selected.attack_profile, global.selected.controlling_player)
	draw_create_weather(global.selected.x, global.selected.y, global.selected, global.selected.weather_profile )
	move_grid_drawn = true;	
}

function draw_possible_moves_selected_astar(){
	var center = get_tile_position(global.selected.x, global.selected.y);
	var origin_x = center[0];
	var origin_y = center[1];
	var range = global.selected.move_points_curr;
	var w = global.grid_cell_width;
	var h = global.grid_cell_height
	if(range > 0)
	{
		for(var i=-range; i<=range; i++){
			for(var j=-range;j<=range;j++){
				if(global.pathfinder != noone and not(i==0 and j==0))
				{
					show_debug_message("Pathfinding from ("+string(origin_x) +","+string(origin_y) +") to ("+string(origin_x+i) +","+string(origin_y+j) +")" )
					//Find path
					var astar_path_result;
					with(global.pathfinder)
					{
						var start_tile = instance_position(origin_x*w, origin_y*h, par_pathfinding_tile);
						var destination_tile = instance_position((origin_x+i)*w,(origin_y+j)*h, par_pathfinding_tile);
						//show_debug_message(string(start_tile)+"->"+string(destination_tile));
						astar_path_result = get_astar_path(start_tile, destination_tile, global.selected.unit_profile.movement_type)
					}
					//show_debug_message("Path found: " + string(astar_path_result.path_found))
					//Create path object
					if(astar_path_result.path_found)
					{
						//show_debug_message("Path Cost: " + string(astar_path_result.cost) +"/" + string(range))
						//Check if the path cost is in movement range and it is not occupied
						var occupied = instance_position((origin_x+i+1/2)*w,(origin_y+j+1/2)*h, par_abstract_unit) != noone
						if(astar_path_result.cost <= range and not occupied)
						{
							//Create move possible
							var move_possible = instance_create_layer((origin_x+i)*w,(origin_y+j)*h ,"Pathing", obj_move_possible);
							with(move_possible){
								linked_attack_profile = global.selected.attack_profile;
								linked_player = global.selected.controlling_player;
								alarm[0]=1
							}
							//Create path object
							var path = build_astar_path_object(astar_path_result.path, astar_path_result.cost)
							//Link to movement object
							with(move_possible)
							{
								astar_path = path;
							}
						}
					}
				}
			}
		}
		//Add possible attacks from current position
		create_attack_targets(global.selected.x, global.selected.y, global.selected.attack_profile, global.selected.controlling_player)
		draw_create_weather(global.selected.x, global.selected.y, global.selected, global.selected.weather_profile )
		move_grid_drawn = true;
	}
}


function clean_possible_moves() {
	with(obj_move_possible)
	{
		instance_destroy();
	}
	with(obj_move_impossible)
	{
		instance_destroy();
	}
	with(obj_move_currently_selected)
	{
		instance_destroy();
	}
	with(obj_move_attack_possible){
		instance_destroy();
	}
	with(obj_placeholder_attack_command){
		instance_destroy();
	}
	with(obj_attack_preview)
	{
		instance_destroy();
	}
	
	with(obj_placeholder_create_weather_command){
		instance_destroy();
	}
	with(obj_create_weather_preview)
	{
		instance_destroy();
	}
	move_grid_drawn = false;
}


function add_impassible_tiles_to_grid(this_unit, include_units, include_allied_units){
	with(obj_impassible)
	{
		mp_grid_add_instances(global.map_grid,self.id,false);
	}
	if include_units {
		with(par_abstract_unit){
			if self.id != this_unit.id{
				var allied = self.controlling_player == this_unit.controlling_player
				if(include_allied_units or not allied){
					mp_grid_add_instances(global.map_grid,self.id,false);
				}
			}
		}
	}
}

function get_center_of_occupied_tile(occupier){
	var cell_x, cell_y;
	with(occupier){
		cell_x = floor(x/global.grid_cell_width);
		cell_y = floor(y/global.grid_cell_height);
	}
	return get_center_of_cell(cell_x,cell_y);

}

function get_center_of_cell(cell_x, cell_y){
	
	var result;
	result[0] = cell_x * global.grid_cell_width + global.grid_cell_width/2;
	result[1] = cell_y * global.grid_cell_height + global.grid_cell_height/2;
	return result;
}

function get_center_of_tile_for_pixel_position(pixel_x, pixel_y){
	var cell_x = floor(pixel_x/global.grid_cell_width)
	var cell_y  =floor(pixel_y/global.grid_cell_height)
	return get_center_of_cell(cell_x,cell_y);
}

function get_tile_position(pixel_x, pixel_y)
{
	var result;
	result[0] = floor(pixel_x/global.grid_cell_width);
	result[1] = floor(pixel_y/global.grid_cell_height);
	return result;
}
	
	
function navigate(unit, start_x, start_y, end_x, end_y){
	with(unit){
		if(!mp_grid_path(global.map_grid, global.navigate, start_x,start_y,end_x,end_y,global.path_allow_diag))
		{
			show_debug_message("Unable to navigate");
			return false;
		}
		else
		{
			mp_grid_path(global.map_grid, global.navigate, start_x,start_y,end_x,end_y,global.path_allow_diag);
			path_start(global.navigate, global.path_move_speed,path_action_stop ,false);
			return true;
		}
	}
}

function navigate_astar(unit, astar_path)
{
	with(unit)
	{
		var w = global.grid_cell_width;
		var h = global.grid_cell_height
		//Clear path
		path_clear_points(global.navigate)
		for(var i=0; i<ds_list_size(astar_path.ds_path_tiles);i++)
		{
			var tile = astar_path.ds_path_tiles[|i]
			path_add_point(global.navigate, tile.x + w/2, tile.y+h/2,100)
		}
		path_set_closed(global.navigate, false)
		path_start(global.navigate, global.path_move_speed,path_action_stop ,false);
		return true;
	}
}

function can_navigate_unit(unit, grid, path, target_x, target_y){
	return can_navigate(grid,path, unit.x,unit.y,target_x,target_y)
}

function can_navigate(grid,path, start_x, start_y, target_x,target_y){
	return mp_grid_path(grid,path, start_x,start_y,target_x,target_y,global.path_allow_diag)
}

function get_path_length(grid,path,start_x,start_y, target_x,target_y){
	if can_navigate(grid,path, start_x, start_y, target_x,target_y){
		return path_get_length(path)	
	}else{
		return -1
	}

}