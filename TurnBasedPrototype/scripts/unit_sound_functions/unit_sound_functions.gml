function play_random_sound_from_array(sound_array)
{
	if(array_length(sound_array)>0){
		var index= irandom_range(0,array_length(sound_array)-1)
		var sound = sound_array[index]
		audio_sound_gain(sound,global.sfx_gain_base*global.sound_effect_scale*global.sound_master_scale,0)
		audio_play_sound(sound,global.sfx_priority,false)
	}
}

function play_sound(sound)
{
	audio_sound_gain(sound,global.sfx_gain_base*global.sound_effect_scale*global.sound_master_scale,0)
	audio_play_sound(sound,global.sfx_priority,false)
}



#region unit sounds

function build_master_sound_map(){
	
	global.master_sound_map = ds_map_create();
	
	#region generic
	var generic_select_sounds = [snd_unit_generic_select01, snd_unit_generic_select02,snd_unit_generic_select03];
	var generic_move_sounds = [snd_unit_generic_move01, snd_unit_generic_move01]
	var generic_recruit_sounds = [snd_unit_generic_recruit01]
	var generic_attack_move_sounds = [snd_unit_generic_attack_move01]
	var generic_action_sounds = [snd_unit_generic_action01]
	
	var generic_sound_map
	generic_sound_map[sound_map_keys.select] = generic_select_sounds
	generic_sound_map[sound_map_keys.move] = generic_move_sounds;
	generic_sound_map[sound_map_keys.recruit] = generic_recruit_sounds;
	generic_sound_map[sound_map_keys.attack_move] = generic_attack_move_sounds;
	generic_sound_map[sound_map_keys.action] = generic_action_sounds;
	
	ds_map_add(global.master_sound_map,"generic",generic_sound_map);
	#endregion
}

function get_unit_sound_map(snd_map_key){
	if(ds_map_exists(global.master_sound_map, snd_map_key))
	{
		return ds_map_find_value(global.master_sound_map,snd_map_key);	
	}else
	{
		return ds_map_find_value(global.master_sound_map, "generic");	
	}
	

}

#endregion