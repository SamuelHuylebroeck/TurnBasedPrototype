function configure_default_recruitment_stance_matrix(){
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_STANCES.mustering] = 6
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_STANCES.advancing] = 5
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_STANCES.retreating] = 4

	recruitment_stance_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_STANCES.mustering] = 5
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_STANCES.advancing] = 5
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_STANCES.retreating] = 4

	recruitment_stance_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_STANCES.mustering] = 6
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_STANCES.advancing] = 4
	recruitment_stance_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_STANCES.retreating] = 5


}

function configure_default_recruitment_type_matrix(){
	recruitment_type_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_TYPES.raider] = 6
	recruitment_type_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_TYPES.attacker] = 4
	recruitment_type_matrix[TASKFORCE_AI_STANCE.expanding][TASKFORCE_TYPES.defender] = 5

	recruitment_type_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_TYPES.raider] = 5
	recruitment_type_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_TYPES.attacker] = 6
	recruitment_type_matrix[TASKFORCE_AI_STANCE.attacking][TASKFORCE_TYPES.defender] = 4

	recruitment_type_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_TYPES.raider] = 5
	recruitment_type_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_TYPES.attacker] = 4
	recruitment_type_matrix[TASKFORCE_AI_STANCE.defending][TASKFORCE_TYPES.defender] = 6
}
	
function dummy_taskforce_action_scoring_function(action_type, unit, tile, taskforce){
	return 100
}

function get_taskforce_recruitment_request_placeholder(ds_request_queue, taskforce, taskforce_player){
	if ds_list_size(taskforce.ds_list_taskforce_units) < taskforce.taskforce_max_size{
		var placeholder_request = {
			template: obj_unit_flamesword,
			tf: taskforce
			}
		ds_queue_enqueue(ds_request_queue, placeholder_request)
	}
}