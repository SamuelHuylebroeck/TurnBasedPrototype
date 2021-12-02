

function draw_current_option(_x,_y, option){
	switch(option.dd_type){
		case DD_PICKER_TYPES.colour_picker:
			draw_current_option_colour_picker(_x, _y, option)
			break;
		case DD_PICKER_TYPES.map_picker:
		case DD_PICKER_TYPES.player_type_picker:
			draw_current_option_player_type_picker(_x,_y, option)
			break;
		default:
			draw_text(_x,_y, "Option Placeholder")
	}

}

function draw_current_option_colour_picker(_x,_y, option){
	var old_colour = draw_get_color()
	draw_set_color(option.col)
	draw_rectangle(_x,_y, _x+option.w, _y+option.h, false)
	draw_set_color(old_colour)
}

function draw_current_option_player_type_picker(_x,_y, option){
	var old_colour = draw_get_color()
	var old_font = draw_get_font()
	var old_halign = draw_get_halign()
	
	draw_set_color(bg_colour)
	draw_rectangle(_x,_y, _x+option_width, _y+option_height, false)
	
	draw_set_color(text_colour)
	draw_set_halign(fa_left)
	var text = option.text
	draw_text(_x,_y, text)
	
	draw_set_halign(old_halign)
	draw_set_color(old_colour)
	draw_set_font(old_font)
}
	
function draw_dd_option_color(){
	var old_colour = draw_get_color()
	//Draw background
	if highlighted {
		draw_set_color(background_color_highlight)
	}else{
		draw_set_color(background_color_base)
	}
	draw_rectangle(x,y,x+w,y+h, false)
	//Draw colour rectangle
	draw_set_color(option.col)
	draw_rectangle(x+margin,y+margin,x+w-margin,y+h-margin, false)
	draw_set_color(old_colour)
}

function draw_dd_option_string(){
	var old_colour = draw_get_color()
	var old_font = draw_get_font()
	var old_halign = draw_get_halign()
	if highlighted {
		draw_set_color(background_color_highlight)
	}else{
		draw_set_color(background_color_base)
	}
	draw_rectangle(x,y, x+w, y+h, false)
	if highlighted {
		draw_set_color(text_colour_highlight)
	}else{
		draw_set_color(text_colour_base)
	}
	draw_set_halign(fa_left)
	var text = option.text
	draw_text(x,y, text)
	
	draw_set_halign(old_halign)
	draw_set_color(old_colour)
	draw_set_font(old_font)
}

function expand_picker(){
	//Create options
	for(var i=0; i<array_length(options) ; i++){
		var option = options[i];
		var option_instance = instance_create_layer(x, y+(i+1)*option_height ,"Picker_Options",obj_drop_down_picker_option)
		with(option_instance){
			w = other.option_width
			h = other.option_height
			self.option = option
			option_draw_function = other.option_draw_function
			self.picker = other
		}
		ds_list_add(ds_active_options, option_instance)
		
	
	}
	
	expanded=true

}

function collapse_picker(){
	
	for(var i=0; i<ds_list_size(ds_active_options); i++){
		var picker_option = ds_active_options[| i]
		with(picker_option){
			instance_destroy()
		}
	}
	ds_list_clear(ds_active_options)
	expanded = false;

}


function select_option(option, picker){
	picker.current_option = option
	with(picker){
		collapse_picker()
	}

}