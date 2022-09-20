switch(current_state){
	case TASK_STATES.in_progress:
		//check if arrived
		if(not attack_started)
		{
			alarm[1]=1
		}
		//check if attack animation has ended
		if(attack_started and not instance_exists(attack_orchestrator)){
 			current_state=TASK_STATES.done
			unit.has_acted_this_round = true
		}
		break;
	default:
		break;
}