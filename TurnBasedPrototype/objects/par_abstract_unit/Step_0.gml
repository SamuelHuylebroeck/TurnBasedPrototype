/// @description Execute state script

switch(current_state){
	case UNIT_STATES.hurt:
		execute_hurt_state()
		break;
	case UNIT_STATES.dying:
		execute_dying_state()
		break;
	case UNIT_STATES.attacking:
		execute_attack_state();
		break;
	case UNIT_STATES.idle:
	default:
		//Do nothing
		break;
}
