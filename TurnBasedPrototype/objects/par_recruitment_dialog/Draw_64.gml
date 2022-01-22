/// @description Draw frame and layout buttons
var old_halign = draw_get_halign()
var old_valign = draw_get_valign()

draw_set_valign(fa_top)
draw_set_halign(fa_left)

var nr_of_options = ds_list_size(ds_recruitment_options)
var calculated_frame_height = max((nr_of_options+1) * button_height+2*inner_margin, frame_min_height)

var tlc_outer = {
	_x: display_get_gui_width()/2-frame_width/2,
	_y: display_get_gui_height()/2-calculated_frame_height/2

}

var tlc_inner = {
	_x: tlc_outer._x + inner_margin,
	_y: tlc_outer._y + inner_margin
}


#region Draw Frame
draw_sprite_stretched(frame_sprite,0,tlc_outer._x,tlc_outer._y,frame_width, calculated_frame_height)
#endregion

#region debug
if global.debug_gui {
	var gui_screen_middle ={
		_x: display_get_gui_width()/2,
		_y: display_get_gui_height()/2	
	}


	draw_circle(gui_screen_middle._x,gui_screen_middle._y, 8, true)
	draw_line(0,0,gui_screen_middle._x,gui_screen_middle._y)
	draw_line(0,gui_screen_middle._y, gui_screen_middle._x*2,gui_screen_middle._y)
	draw_line(gui_screen_middle._x, 0,gui_screen_middle._x, gui_screen_middle._y)
}
#endregion

 
#region layout buttons

for(var i = 0; i<nr_of_options; i++){
	var option = ds_recruitment_options[| i]
	with(option){
		ui_x = tlc_inner._x
		ui_y = tlc_inner._y+ i*(button_height)
	}
}
//Cancel button
with(cancel_button){
	 ui_x=tlc_outer._x + other.frame_width/2 - button_width/2
	 ui_y=tlc_outer._y + calculated_frame_height - button_height - other.inner_margin
}
#endregion

draw_set_halign(old_halign)
draw_set_valign(old_valign)

