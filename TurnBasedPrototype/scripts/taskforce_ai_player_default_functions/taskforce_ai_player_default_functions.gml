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
	
