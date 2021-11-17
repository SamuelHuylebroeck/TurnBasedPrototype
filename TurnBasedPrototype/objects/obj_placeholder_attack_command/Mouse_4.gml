/// @description Initiate attack
clean_up_attack_preview()
var attack_orchestrator = instance_create_layer(x,y,"Units",obj_attack_orchestrator)
with(attack_orchestrator){
	linked_attacker = other.linked_attacker
	linked_attack_profile = other.linked_attack_profile
	alarm[0]=1
}
instance_destroy()