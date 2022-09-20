

function preview_draw_unit_stats_block(tl_x, tl_y, width, height, fonts, unit_profile)
{
	
	var separator = 4;
	
	//draw_rectangle(tl_x, tl_y, tl_x+width, tl_y+height, true)
	draw_sprite_stretched(spr_frame, 0, tl_x, tl_y, width, height)
	
	var name_font = fonts[1]
	draw_set_font(name_font)
	draw_text(tl_x+separator, tl_y+separator, unit_profile.verbose_name);
	var running_y = tl_y + string_height(unit_profile.verbose_name)+2*separator
	draw_rectangle(tl_x+separator, running_y-separator,tl_x+string_width(unit_profile.verbose_name),running_y-separator, false)
	running_y += sprite_get_height(spr_stats_icon_hp)/2
	draw_set_valign(fa_middle)
	draw_set_font(fonts[0])
	running_y+=draw_single_stat_line(tl_x+separator, running_y,spr_stats_icon_hp, ": " + string(unit_profile.max_hp), separator);
	running_y+=draw_single_stat_line(tl_x+separator, running_y,get_movement_icon(unit_profile.movement_type), ": " + string(unit_profile.base_movement), separator);
	running_y+=draw_single_stat_line(tl_x+separator, running_y,spr_stats_icon_armour, ": " + string(unit_profile.base_armour), separator);
	running_y+=draw_single_stat_line(tl_x+separator, running_y,spr_stats_icon_avoid, ": " + string(unit_profile.base_avoid), separator);

	
}

function preview_draw_attack_stats_block(tl_x, tl_y, width, height, fonts, attack_stats_profile)
{
	var separator = 4;
	
	//draw_rectangle(tl_x, tl_y, tl_x+width, tl_y+height, true)
	draw_sprite_stretched(spr_frame, 0, tl_x, tl_y, width, height)
	var running_y = tl_y + separator+sprite_get_height(spr_stats_icon_damage)/2;
	running_y+=draw_single_stat_line(tl_x+separator, running_y, spr_stats_icon_damage, ": " + string(attack_stats_profile.base_damage),separator)
	running_y+=draw_single_stat_line(tl_x+separator, running_y, spr_stats_icon_accuracy, ": " + string(attack_stats_profile.base_accuracy),separator)
	running_y+=draw_single_stat_line(tl_x+separator, running_y, get_shape_icon(attack_stats_profile.base_shape), ": " + string(attack_stats_profile.base_size),separator)
	running_y = tl_y + separator+sprite_get_height(spr_stats_icon_damage)/2;
	running_y+=draw_single_stat_line(tl_x+separator+width/2, running_y, spr_stats_icon_piercing, ": " + string(attack_stats_profile.base_piercing),separator)
	running_y+=draw_single_stat_line(tl_x+separator+width/2, running_y, spr_stats_icon_range, ": " + string(attack_stats_profile.min_range)+"-"+string(attack_stats_profile.max_range),separator)
	
}

function preview_draw_weather_stats_block(tl_x, tl_y, width, height, fonts, weather_stats_profile)
{
	var separator = 4;
	//draw_rectangle(tl_x, tl_y, tl_x+width, tl_y+height, true)
	draw_sprite_stretched(spr_frame, 0, tl_x, tl_y, width, height)
	var running_y = tl_y + separator+sprite_get_height(spr_stats_icon_damage)/2;
	running_y+=draw_single_stat_line(tl_x+separator, running_y, get_element_icon(weather_stats_profile.weather_element), ": " + string(weather_stats_profile.verbose_name),separator)
	running_y+=draw_single_stat_line(tl_x+separator, running_y, spr_stats_icon_duration, ": " + string(weather_stats_profile.weather_duration),separator)
	running_y+=draw_single_stat_line(tl_x+separator, running_y, spr_stats_icon_shape_burst, ": " + string(weather_stats_profile.weather_burst_size),separator)
}
function preview_draw_descriptions_block(tl_x, tl_y, width, height, fonts, description)
{
	var separator = 4;
	//draw_rectangle(tl_x, tl_y, tl_x+width, tl_y+height, true)
	draw_sprite_stretched(spr_frame, 0, tl_x, tl_y, width, height)
	var text_font = fonts[0]
	draw_set_font(text_font)
	draw_set_valign(fa_top)
	draw_text(tl_x+separator, tl_y+separator, description)
}

function draw_single_stat_line(tl_x, tl_y, sprite, text, separator)
{
	draw_sprite(sprite, 0, tl_x, tl_y)
	var width = separator + sprite_get_width(sprite)
	draw_text(tl_x+width,tl_y, text)
	return max(sprite_get_height(sprite), string_height(text))+separator
}

function get_shape_icon(shape)
{
		var icon_sprite;
		switch(shape){
			case ATTACK_SHAPES.as_line:
				icon_sprite = spr_stats_icon_shape_hline;
				break;
			case ATTACK_SHAPES.as_wall:
				icon_sprite = spr_stats_icon_shape_vline;
				break;
			case ATTACK_SHAPES.as_cone:
				icon_sprite = spr_stats_icon_shape_cone;
				break;
			case ATTACK_SHAPES.as_blast:
				icon_sprite = spr_stats_icon_shape_blast;
				break;
			case ATTACK_SHAPES.as_burst:
				icon_sprite = spr_stats_icon_shape_burst;
				break;
			default:
				icon_sprite = spr_stats_icon_placeholder;
		}
		
		return icon_sprite
}

function get_movement_icon(movement_type)
{
		var icon_sprite;
		switch(movement_type){
			case MOVEMENT_TYPES.flying:
				icon_sprite = spr_stats_icon_movement_flying;
				break;
			case MOVEMENT_TYPES.heavy:
				icon_sprite = spr_stats_icon_movement_heavy;
				break;
			case MOVEMENT_TYPES.foot:
				icon_sprite = spr_stats_icon_movement_foot;
				break;
			default:
				icon_sprite = spr_stats_icon_placeholder;
		}
		
		return icon_sprite
}

function get_element_icon(element)
{
		var icon_sprite;
		switch(element){
			case WEATHER_ELEMENTS.fire:
				icon_sprite = spr_stats_icon_element_fire
				break;
			case WEATHER_ELEMENTS.water:
				icon_sprite = spr_stats_icon_element_water
				break;
			case WEATHER_ELEMENTS.wind:
				icon_sprite = spr_stats_icon_element_wind
				break;
			case WEATHER_ELEMENTS.earth:
				icon_sprite = spr_stats_icon_element_earth
				break;
			default:
				icon_sprite = spr_stats_icon_placeholder;
		}
		
		return icon_sprite
}