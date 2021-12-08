if started{
	done = check_for_attack_end(linked_unit, ds_weather_effect_objects)
	if (done){
		//Clean up
		end_attack(linked_unit)
		//delete itself
		instance_destroy()
	}
}