/// @description ??
switch(executor_state){
	case TASK_STATES.in_progress:
		if current_taskforce == noone{
			var next_tf = ds_queue_dequeue(taskforce_queue)
			if next_tf != undefined {
				current_taskforce = next_tf
				gather_task_force_executors(next_tf, current_taskforce_executors_queue)
			}else{
				//All taskforces are done
				executor_state=TASK_STATES.done
			}
		}
		if current_task == noone{
			//Get the next executor from the queue
			var next_exec = ds_queue_dequeue(current_taskforce_executors_queue)
			if next_exec != undefined  and instance_exists(next_exec){
				//Gather tasks and decide on next one
				var player = next_exec.controlling_player
				var next_task = get_next_task(next_exec, current_taskforce, player)
				//Start executing next one
				current_task = next_task
				if current_task != noone {
					current_task.alarm[0] =1
				}

			
			}else{
				//This taskforce is done, check objectives and move on to the next one
				current_taskforce = noone
			}
		}else{
			if(current_task.current_state == TASK_STATES.done){
				//Clean up done task
				show_debug_message("Cleanup")
				var player = current_task.unit.controlling_player
				update_objectives_taskforce(current_taskforce, player)
				instance_destroy(current_task)
				current_task=noone
			}
		}
		
	default:
		break;
}