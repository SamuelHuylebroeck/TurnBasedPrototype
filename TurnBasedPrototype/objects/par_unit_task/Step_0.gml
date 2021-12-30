/// @description Center camera on unit
switch(current_state){
	case TASK_STATES.in_progress:
		pan_camera_to_center_on_position(unit.x,unit.y,0.05)
		break;
	default:
		break;
}