/// @description Zoom an pan controls
// You can write your code in this editor
if(global.camera_controllable and player_in_control)
{
	player_zoom();
	player_pan();
}else{
	//Smooth zoom and pan here
	smooth_pan();
}
