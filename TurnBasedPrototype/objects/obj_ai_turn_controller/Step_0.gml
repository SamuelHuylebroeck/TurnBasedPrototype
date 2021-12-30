/// @description ??
if active {
	switch(current_state){
		case AI_TURN_CONTROLLER_STATES.task_force_management:
			execute_task_force_management(linked_ai_player)
			break;
		case AI_TURN_CONTROLLER_STATES.recruitment:
			execute_taskforce_recruitment(linked_ai_player)
			break;
		case AI_TURN_CONTROLLER_STATES.task_force_execution:
			execute_task_force_execution(linked_ai_player)
			break;
		case AI_TURN_CONTROLLER_STATES.done:
			global.ai_turn_completed = true
			break;
		default:
			show_debug_message("AI controller state is undefined")
			
	}


}