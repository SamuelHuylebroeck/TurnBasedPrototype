/// @description ??
if(global.debug_draw_grid){
	draw_set_alpha(0.5);
	draw_set_color(c_blue);
	mp_grid_draw(global.map_grid);
	draw_set_alpha(1);
}