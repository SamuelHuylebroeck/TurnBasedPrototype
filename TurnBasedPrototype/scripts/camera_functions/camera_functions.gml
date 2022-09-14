//@description ??
function player_zoom(){
	if (mouse_wheel_down() || keyboard_check_pressed(vk_add))
		{
			if(camera_width<max_camera_width)
			{
				camera_width += camera_zoom_step;
				camera_height += camera_zoom_step/aspect_ratio;
				camera_set_view_size(camera,camera_width,camera_height);
				camera_set_view_border(camera,camera_width,camera_height);
				//Correction for zoom out
				camera_x = camera_get_view_x(camera);
				camera_y = camera_get_view_y(camera);
				if(camera_x > room_width - camera_width)
				{
					camera_x = room_width - camera_width;
				}
				if(camera_y >room_height - camera_height)
				{
					camera_y = room_height - camera_height;
				}
				camera_x = camera_x <0 ? 0 : camera_x;
				camera_y = camera_y <0 ? 0:camera_y;
				camera_set_view_pos(camera, camera_x,camera_y);
		
			}
		}else if (mouse_wheel_up() || keyboard_check_pressed(vk_subtract))
		{
			if(camera_width>min_camera_width)
			{
			    camera_width -= camera_zoom_step;
				camera_height -= camera_zoom_step/aspect_ratio;
				camera_set_view_size(camera,camera_width,camera_height);
				camera_set_view_border(camera,camera_width,camera_height);
			}
		}
}

function player_pan(){
//get current camera positions
	var camera_x = camera_get_view_x(camera);
	var camera_y = camera_get_view_y(camera);

	var camera_width = camera_get_view_width(camera);
	var camera_height = camera_get_view_height(camera);
	var up_pressed = keyboard_check(ord(global.up)) or keyboard_check(vk_up)
	var down_pressed = keyboard_check(ord(global.down)) or keyboard_check(vk_down)
	var left_pressed = keyboard_check(ord(global.left)) or keyboard_check(vk_left)
	var right_pressed = keyboard_check(ord(global.right)) or keyboard_check(vk_right)
	
	var m_x = device_mouse_x_to_gui(0)
	var m_y = device_mouse_y_to_gui(0)

	
	if( (up_pressed or m_y < edge_pan_zone) and camera_y > 0 )
	{
		camera_y -= camera_pan_step;
	}
	//(mouse_y > display_get_gui_height()-edge_pan_zone)
	if( (down_pressed or m_y > display_get_gui_height()-edge_pan_zone)  and camera_y < room_height - camera_height)
	{
		camera_y += camera_pan_step;
	}

	if( (left_pressed or m_x <edge_pan_zone) and camera_x> 0)
	{
		camera_x -= camera_pan_step;
	}

	if((right_pressed or m_x > display_get_gui_width()-edge_pan_zone) and camera_x < room_width - camera_width)
	{
		camera_x += camera_pan_step;
	}

	camera_set_view_pos(camera,camera_x,camera_y);

}
	
function smooth_pan(){
	//origin_x_origin_y
	var time_elapsed = counter / game_get_speed(gamespeed_fps)
	var relative_progress = clamp(0,time_elapsed/pan_duration, 1)
	
	if(return_control_on_pan_end and relative_progress >= 1)
	{
		player_in_control = true;
		return_control_on_pan_end = false;
	}
	
	//Clamp target to room bounds
	target_x = clamp(target_x, 0, room_width - camera_width)
	target_y = clamp(target_y, 0, room_height - camera_height)
	var pan_curve = animcurve_get(smooth_pan_curve_struct)
	var channel = animcurve_get_channel(pan_curve,"x" )
	var curve_pos = animcurve_channel_evaluate(channel, relative_progress)
	//smooth move to position
	var camera_x = lerp(previous_position_x, target_x, curve_pos)
	var camera_y= lerp(previous_position_y, target_y, curve_pos)
	camera_set_view_pos(camera, camera_x, camera_y)
	counter++
}

function pan_camera_to_center_on_position(pos_x,pos_y,duration,take_control=false){
	if global.debug_camera show_debug_message("Panning camera to ["+string(pos_x)+","+string(pos_y)+"] in "+string(duration)+"s")

	with(obj_camera){
		previous_position_x = camera_get_view_x(camera)
		previous_position_y = camera_get_view_y(camera)
		target_x=pos_x-camera_width/2
		target_y=pos_y-camera_height/2
		pan_duration=duration
		counter=0
		
		if(take_control)
		{
			player_in_control = false;
			return_control_on_pan_end = true;
		}
	}
}