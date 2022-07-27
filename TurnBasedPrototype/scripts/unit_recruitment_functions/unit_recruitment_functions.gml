//@description ??
function start_recruitment(recruitment_building)
{
	//Disable controls
	deselect()
	global.player_permission_selection = false;
	global.player_permission_execute_orders = false;
	//Create recruitment governing dialog
	var recruitment_dialog = instance_create_layer(0,0,"UI_Frames", obj_placeholder_recruitment_dialog)
	
	////Create options
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

function start_recruitment_tabbed(recruitment_building)
{
	deselect()
	global.player_permission_selection = false;
	global.player_permission_execute_orders = false;
	//Create recruitment governing dialog
	var recruitment_dialog = instance_create_layer(0,0,"UI_Frames", obj_tabbed_recruitment_dialog)
	with(recruitment_dialog)
	{
		//Create tabs
		var player = recruitment_building.controlling_player
		var keys = [] 
		keys = ds_map_keys_to_array(player.ds_tabbed_recruitment_options)
		array_sort(keys,false)
		for(var a = 0; a<array_length(keys);a++)
		{
			var key = keys[a]
			var tab_rec_options = ds_map_find_value(player.ds_tabbed_recruitment_options, key)
			ds_map_add(ds_recruitment_options, key, tab_rec_options);
		
			var tab = instance_create_layer(0,0,"UI", obj_tabbed_recruitment_tab)
			with(tab)
			{
				tab_text = key;
				dialog_index = a;
				initialized = true;
				dialog = other;
			}
			ds_list_add(ds_tabs , tab)
		}
	
		current_active_tab = 0
		self.recruitment_building = recruitment_building;
		with(ds_tabs[|current_active_tab])
		{
			selected = true;
		}
		construct_tab_options(ds_tabs[|current_active_tab].tab_text, self.recruitment_building)
	}	
}

function switch_tab(key, index)
{
	clear_current_tab()
	current_active_tab = index
	construct_tab_options(key, self.recruitment_building)
	ds_tabs[|current_active_tab].selected = true;
}

function clear_current_tab()
{
	cancel_current_preview();
	current_active_option = -1;
	for(var i=0;i<ds_list_size(ds_current_active_options);i++)
	{
		with(ds_current_active_options[|i])
		{
			instance_destroy();
		}
	}
	ds_list_clear(ds_current_active_options)
	ds_tabs[|current_active_tab].selected = false;
	
}

function construct_tab_options(key, recruitment_building)
{
	var options = ds_map_find_value(ds_recruitment_options, key)
	for(var i=0;i<ds_list_size(options);i++)
	{
		var option = options[|i];
		var recruit_option = instance_create_layer(0,0,"UI", obj_tabbed_recruitment_recruit_option)
		with(recruit_option)
		{
			
			self.recruitment_option_detail = option
			self.recruitment_building = recruitment_building
			self.recruiting_player = recruitment_building.controlling_player
			self.initialized = true
			self.dialog_index = i;
			self.dialog = other;
		}
		ds_list_add(ds_current_active_options, recruit_option)
	}
}

function select_for_recruitment(index)
{
	if(current_active_option != -1)
	{
		ds_current_active_options[|current_active_option].selected = false;
	}
	current_active_option = index
	create_preview(current_active_option)
	ds_current_active_options[|current_active_option].selected = true;
}

function create_preview(index)
{
	cancel_current_preview()
	
	current_preview = instance_create_layer(0,0,"UI", obj_tabbed_recruitment_preview);
	with(current_preview)
	{
		initialized = true;
	}
	
}

function cancel_current_preview(){
	if current_preview != noone
	{
		instance_destroy(current_preview);
	}
	current_preview = noone;
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
	with(obj_tabbed_recruitment_dialog)
	{
		instance_destroy()
	}
	with(obj_tabbed_recruitment_tab)
	{
		instance_destroy()
	}
	with(obj_tabbed_recruitment_recruit_option)
	{
		instance_destroy()
	}
	with(obj_tabbed_recruitment_cancel)
	{
		instance_destroy()
	}
	with(obj_tabbed_recruitment_preview)
	{
		instance_destroy()	
	}
	with(obj_tabbed_recruitment_recruit_button)
	{
		instance_destroy()	
	}
	global.player_permission_selection = true;
	global.player_permission_execute_orders = true;
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