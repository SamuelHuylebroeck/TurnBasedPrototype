/// @description ??
if(current_track != noone)
{
	if(not paused)
	{
		if(not audio_is_playing(current_track))
		{
			jukebox_next()
		}
	}
}

