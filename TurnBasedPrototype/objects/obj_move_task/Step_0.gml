/// @description ??
/// @description Center camera on unit
switch(current_state){
	case TASK_STATES.in_progress:
		//check if arrived
		if (unit.path_index == -1)
		{
			current_state=TASK_STATES.done
			unit.has_acted_this_round = true
		}
		break;
	default:
		break;
}