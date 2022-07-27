/// @description ??
var fonts = global.ui_scale_values[global.current_ui_scale][2]
var x_scale = global.ui_scale_values[global.current_ui_scale][0]
var y_scale = global.ui_scale_values[global.current_ui_scale][1]
var old_color = draw_get_color()


#region layout helpers
var width=base_width_rel*global.ui_width
var height=base_height_rel*global.ui_height

var tl_x = anchor_x*global.ui_width;
var tl_y = anchor_y*global.ui_height;

var preview_frame_width = preview_frame_width_rel * width
var tl_pf_x = tl_x + (width-preview_frame_width)
var tl_pf_y = tl_y

var list_frame_width = width-preview_frame_width
#endregion

#region frames
draw_sprite_stretched(spr_frame,0,tl_x, tl_y, list_frame_width, height)
draw_sprite_stretched(spr_frame,0,tl_pf_x,tl_pf_y, preview_frame_width, height)
#endregion

#region layout tabs
var nr_tabs = ds_list_size(ds_tabs)
var tab_seperator = 0
for(var i=0;i<ds_list_size(ds_tabs);i++)
{
	with(ds_tabs[|i])
	{
		ui_x = tl_x + i*(list_frame_width/(nr_tabs) + tab_seperator) + other.inner_frame_margin
		ui_y = tl_y + tab_seperator + other.inner_frame_margin
		max_width = (list_frame_width/(nr_tabs)-2*other.inner_frame_margin)-tab_seperator
		max_height = 0.2*height
		min_width = 32
		min_height = 0.05*height
	}
}
#endregion

#region layout options
var option_height = 32
var header_height = ds_tabs[|0].height
for(var i=0;i<ds_list_size(ds_current_active_options);i++)
{
	with(ds_current_active_options[|i])
	{
		ui_x = tl_x + tab_seperator + other.inner_frame_margin
		ui_y = tl_y + i *option_height + tab_seperator+header_height+other.inner_frame_margin
		max_width = list_frame_width-2*tab_seperator - 2*other.inner_frame_margin
		max_height = option_height
		min_width = 32
		min_height = 32
	}
}
#endregion

#region layout preview
if(current_preview != noone)
{
	
	with(current_preview)
	{
		ui_x = tl_pf_x
		ui_y = tl_pf_y
		max_width = preview_frame_width
		max_height = height
	}

}

#endregion

#region layout recruit and cancel button
var selection_recruitable = false;

if(current_active_option != -1)
{
	var option = ds_current_active_options[|current_active_option]
	selection_recruitable = can_player_recruit(option.recruiting_player, option.recruitment_option_detail, option.recruitment_building);
}

with(recruit_button)
{
	ui_x = tl_x
	ui_y = tl_y+height
	max_width = list_frame_width
	self.selection_recruitable = selection_recruitable
}
with(cancel_button)
{
	ui_x = tl_x+width
	ui_y = tl_y
}
#endregion

draw_set_color(old_color)

#region cancel if clicked outside of recruitment window
var hover = is_mouse_hovering_over_gui_element(tl_x, tl_x, width, height)
var click_outside = !hover && mouse_check_button_pressed(mb_right)

if click_outside cancel_recruitment();
#endregion