/// @description ??
switch(current_state){
	case TASK_STATES.in_progress:
			current_state=TASK_STATES.done
			unit.has_acted_this_round = true
		break;
	default:
		break;
}