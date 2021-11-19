/// @description ??
switch(current_state){
	case WEATHER_STATES.fading:
		execute_fading_state()
		break;
	case WEATHER_STATES.present:
	default:
		//Do nothing
		execute_present_state()
		break;
}