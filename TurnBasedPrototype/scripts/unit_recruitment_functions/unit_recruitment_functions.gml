//@description ??
function start_recruitment(recruitment_building)
{
	//Disable controls
	deselect()
	//Create recruitment governing dialog
	var recruitment_dialog = instance_create_layer(0,0,"UI_Frames", obj_placeholder_recruitment_dialog)
	
	//Create options
	var player = recruitment_building.controlling_player
	for(var i=0; i< ds_list_size(player.ds_recruitment_options); i++){
		var option = player.ds_recruitment_options[| i]
		var option_object = instance_create_layer(0,0, "UI", obj_placeholder_recruitment_option)
		with(option_object){
			self.recruitment_option_detail = option
			self.recruitment_building = recruitment_building
			self.recruiting_player = player
			self.initialized = true
		}
		ds_list_add(recruitment_dialog.ds_recruitment_options, option_object)
	
	}
	
}

function cancel_recruitment(){
	with(par_recruitment_option){
		instance_destroy()
	}
	with(obj_recruitment_dialog_cancel){
		instance_destroy()
	}
	with(par_recruitment_dialog){
		instance_destroy()
	}
	with(obj_recruitment_placement_option){
		instance_destroy()
	}
}

function can_player_recruit(player, recruitment_option, recruitment_building){
	return recruitment_option.cost <= player.player_current_resources and recruitment_building.current_state == BUILDING_STATES.ready
}

function create_recruitment_placement_opportunities(recruitment_building, unit_template, player, cost){
	var radius = 1
	var center = get_center_of_occupied_tile(recruitment_building)
	for (var i=-radius;i<=radius;i++){
		for(var j=-radius;j<=radius;j++){
			if(abs(i)+abs(j) <=radius){
				var tile_occupied=instance_position(center[0]+i*global.grid_cell_width, center[1]+j*global.grid_cell_height, par_abstract_unit) != noone
				var passable = instance_position(center[0]+i*global.grid_cell_width, center[1]+j*global.grid_cell_height, obj_impassible) == noone
				
				if (not tile_occupied and passable){
					var recruitment_placement_option = instance_create_layer(center[0]+i*global.grid_cell_width, center[1]+j*global.grid_cell_height, "Units", obj_recruitment_placement_option)
					with(recruitment_placement_option){
						self.template = unit_template
						self.player = player
						self.recruitment_building = recruitment_building
						self.cost = cost
					}
				}
			}
		}
	}
}

function execute_recruitment(pos_x, pos_y, recruitment_building, unit_template, player, cost){
	//Create unit on location
	var unit = instance_create_layer(pos_x,pos_y, "Units", unit_template)
	with(unit){
		controlling_player = player
		has_acted_this_round = true
	}
	//deduct cost
	player.player_current_resources -= cost
	//mark building as exhausted
	recruitment_building.current_state = BUILDING_STATES.exhausted
	//Add to list of units player controls
	ds_list_add(player.ds_active_units, unit)
	play_random_sound_from_array(unit.unit_sound_map[sound_map_keys.recruit])
	
	cancel_recruitment()
	return unit

}
	
function get_available_recruitment_tiles(recruitment_building){
	var list_available_tiles = ds_list_create()
	for(var i=-1; i<=1;i++){
		for(var j=-1; j<=1;j++){
			if(abs(i)+abs(j) <2){
				//Add if noone is there and if the tile is passable
				var candidate_x = recruitment_building.x+i*global.grid_cell_width
				var candidate_y = recruitment_building.y+j*global.grid_cell_height
				var not_occupied = (instance_position(candidate_x,candidate_y, par_abstract_unit)==noone)
				var passable = (instance_position(candidate_x,candidate_y, obj_impassible)==noone)
				if not_occupied and passable {
					var position = {_x: candidate_x, _y: candidate_y}
					ds_list_add(list_available_tiles, position)
				}
			}
		}
	}
	return list_available_tiles

}