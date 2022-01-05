/// @description ??
/// @description Center camera on unit
switch(current_state){
	case TASK_STATES.in_progress:
		//check if arrived
		if (unit.path_index == -1 and not move_completed and not attack_started)
		{
			alarm[2]=1
			move_completed = true
		}
		//check if attack animation has ended
		if(move_completed and attack_started and not instance_exists(attack_orchestrator)){
 			current_state=TASK_STATES.done
			unit.has_acted_this_round = true
		}
		break;
	default:
		break;
}