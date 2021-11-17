if started{
	done = check_for_attack_end(linked_attacker, ds_attack_effect_objects)
	if (done){
		//Clean up
		end_attack(linked_attacker)
		//delete itself
		instance_destroy()
	}
}