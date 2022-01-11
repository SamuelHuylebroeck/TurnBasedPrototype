/// @description Force taskforces into retreat
show_debug_message("Putting taskforces into retreat")
with(par_ai_taskforce){
	taskforce_stance = TASKFORCE_STANCES.retreating
}