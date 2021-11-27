//@description ??
function draw_possible_moves_selected(){
	mp_grid_clear_all(global.map_grid);
	add_impassible_tiles_to_grid(global.selected)
		//Draw
	var center = get_center_of_occupied_tile(global.selected);
	var center_x = center[0];
	var center_y = center[1];
	var range = global.selected.move_points_total_current;
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
					if(!position_meeting(i_x,i_y, par_abstract_unit)){
						move_possible = instance_create_layer(i_x - w/2,i_y - h/2 ,"Pathing", obj_move_possible);
						with(move_possible){
							linked_attack_profile = global.selected.attack_profile;
							linked_player = global.selected.controlling_player;
							alarm[0]=1
						}
					}
				}else{
					instance_create_layer(i_x - w/2,i_y-h/2,"Pathing", obj_move_impossible);
				}
			}
		
		}
	}
	//Add possible attacks from current position
	draw_attack_targets(global.selected.x, global.selected.y, global.selected.attack_profile, global.selected.controlling_player)
	move_grid_drawn = true;	
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
	move_grid_drawn = false;
}


function add_impassible_tiles_to_grid(this_unit){
	with(obj_impassible)
	{
		mp_grid_add_instances(global.map_grid,self,false);
	}
	with(par_abstract_unit){
		if self.id != this_unit.id{
			mp_grid_add_instances(global.map_grid,self,false);
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
	
	
function navigate(unit, start_x, start_y, end_x, end_y){
	with(unit){
		if(!mp_grid_path(global.map_grid, global.navigate, start_x,start_y,end_x,end_y,global.path_allow_diag))
		{
			show_message("Unable to navigate");
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