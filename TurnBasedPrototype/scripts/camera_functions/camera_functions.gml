//@description ??

function zoom(){
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

function pan(){
//get current camera positions
	var camera_x = camera_get_view_x(camera);
	var camera_y = camera_get_view_y(camera);

	var camera_width = camera_get_view_width(camera);
	var camera_height = camera_get_view_height(camera);
	var up_pressed = keyboard_check(ord(global.up)) or keyboard_check(vk_up)
	var down_pressed = keyboard_check(ord(global.down)) or keyboard_check(vk_down)
	var left_pressed = keyboard_check(ord(global.right)) or keyboard_check(vk_left)
	var right_pressed = keyboard_check(ord(global.right)) or keyboard_check(vk_right)

	
	if(up_pressed and camera_y > 0 )
	{
		camera_y -= camera_pan_step;
	}

	if(down_pressed and camera_y < room_height - camera_height)
	{
		camera_y += camera_pan_step;
	}

	if(left_pressed and camera_x> 0)
	{
		camera_x -= camera_pan_step;
	}

	if(right_pressed  and camera_x < room_width - camera_width)
	{
		camera_x += camera_pan_step;
	}

	camera_set_view_pos(camera,camera_x,camera_y);

}