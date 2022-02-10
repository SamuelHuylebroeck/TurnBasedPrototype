function load_config_from_file()
{
	var file = file_text_open_read(working_directory + "settings.config");
	var json_string =""
	while(!file_text_eof(file))
	{
		json_string	+= file_text_readln(file)
	}
	var config_map = json_decode(json_string)
	file_text_close(file)
	return config_map
}


function clean_up_config_map(config_map)
{
	ds_map_destroy(config_map)
}

function save_config_to_file(grid_audio, grid_video, grid_controls, grid_game)
{
	//Create maps
	var file = file_text_open_write(working_directory + "settings.config");
	var config_map = ds_map_create()
	
	#region audio
	var audio_map = ds_map_create()
	var keys = ["master", "sfx", "music"]
	var i=0; repeat(array_length(keys))
	{
		ds_map_add(audio_map, keys[i], grid_audio[# 3, i])
		i++;
	}
	ds_map_add_map(config_map, "audio", audio_map)
	#endregion
	
	#region video
	var video_map = ds_map_create()
	keys = ["resolution", "fullscreen", "ui_scale"]
	i=0; repeat(array_length(keys))
	{
		ds_map_add(video_map, keys[i], grid_video[# 3, i])
		i++;
	}
	ds_map_add_map(config_map, "video", video_map)
	#endregion
	
	#region game
	var game_map = ds_map_create()
	keys = ["show_healthbars", "fast_pathing"]
	i=0; repeat(array_length(keys))
	{
		ds_map_add(game_map, keys[i], grid_game[# 3, i])
		i++;
	}
	ds_map_add_map(config_map, "game", game_map)
	#endregion
	
	var config_string = json_encode(config_map)
	file_text_write_string(file, config_string)
	file_text_writeln(file)
	file_text_close(file)
	ds_map_destroy(config_map)

}