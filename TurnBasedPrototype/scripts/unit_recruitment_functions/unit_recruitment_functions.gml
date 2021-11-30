//@description ??
function start_recruitment(recruitment_building)
{
	//Disable controls
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
}

function can_player_recruit(player, recruitment_option, recruitment_building){
	return recruitment_option.cost <= player.player_current_resources and recruitment_building.current_state == BUILDING_STATES.ready
}

function execute_recruitment(recruitment_building, unit_template, player, cost){
	//Create unit on location
	var unit = instance_create_layer(recruitment_building.x, recruitment_building.y, "Units", unit_template)
	with(unit){
		controlling_player = player
		has_acted_this_round = true
	}
	//deduct cost
	player.player_current_resources -= cost
	//mark building as exhausted
	recruitment_building.current_state = BUILDING_STATES.exhausted
	
	cancel_recruitment()
	

}