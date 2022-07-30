/// @description draw stat card
if (unit != noone and instance_exists(unit)){
	var max_width = global.ui_width * max_gui_width
	var max_height = global.ui_height * max_gui_heigth
	
	draw_unit_stat_card(unit, max_width, max_height, internal_offset_x,internal_offset_y, text_colour)
}