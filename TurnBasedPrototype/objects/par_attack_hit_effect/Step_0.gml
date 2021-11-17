/// @description ??
if not done and image_speed >0 {
	if ( image_index + (sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps)) >= image_number ){
		//Create terrain
		
		//
		visible=false
		image_speed=0
		done = true
		
	}
}