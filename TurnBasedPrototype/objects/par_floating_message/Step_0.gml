/// @description Adjust position and transparancy
image_alpha -= fade_step
if(image_alpha <= 0){
	instance_destroy()
}

y-= upward_float_speed

