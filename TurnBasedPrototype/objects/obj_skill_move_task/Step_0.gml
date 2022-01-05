/// @description ??
/// @description Center camera on unit
switch(current_state){
	case TASK_STATES.in_progress:
		//check if arrived
		if (unit.path_index == -1 and not move_completed and not skill_started)
		{
			alarm[2]=1
			move_completed = true
		}
		//check if attack animation has ended
		if(move_completed and skill_started and not instance_exists(skill_orchestrator)){
			current_state=TASK_STATES.done
			unit.has_acted_this_round = true
		}
		break;
	default:
		break;
}