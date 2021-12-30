/// @description ??
switch(executor_state){
	case TASK_STATES.in_progress:
		if current_task == noone{
			//Check if we are done
			if ds_queue_empty(recruitment_task_queue){
				executor_state = TASK_STATES.done
			
			}
			//Pop a new one
			current_task = ds_queue_dequeue(recruitment_task_queue)
			if current_task != undefined{
				current_task.alarm[0]=1
			}
		
		}else{
			if(current_task.current_state == TASK_STATES.done){
				//Clean up done task
				instance_destroy(current_task)
				current_task = noone
			}
		}
		
	default:
		break;
}