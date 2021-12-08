/// @description ??
draw_sprite_stretched(frame_sprite,0,x,y,w,h)

//Draw minimap
if map_picker != noone and map_picker.current_option != noone {
	var minimap_sprite = map_picker.current_option.minimap
	draw_sprite(minimap_sprite,0,x+minimap_offset, y)

}