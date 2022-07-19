function jukebox_play(sound_id, priority, loop=false)
{
	audio_sound_gain(sound_id,global.music_base_gain*global.sound_music_scale*global.sound_master_scale,0)	
	audio_play_sound(sound_id, priority, false);
}

function jukebox_pause()
{
	audio_pause_sound(current_track)
	paused=true;
}

function jukebox_resume()
{
	audio_resume_sound(current_track)
	paused=false;
}

function jukebox_next()
{
	if(audio_is_playing(current_track))
	{
		audio_stop_sound(current_track)
	}
	current_track_index = (current_track_index +1)%array_length(track_library)
	current_track = track_library[current_track_index]
	jukebox_play(current_track,jukebox_priority,false)
}

function jukebox_previous()
{
	if(audio_is_playing(current_track))
	{
		audio_stop_sound(current_track)
	}
	current_track_index = (current_track_index -1)%array_length(track_library)
	current_track_index = current_track_index <0 ? array_length(track_library)-1 :current_track_index
	current_track = track_library[current_track_index]
	jukebox_play(current_track,jukebox_priority,false)
}