
#region colour definitions

#macro c_soft_blue make_colour_rgb(46,61,96)
#macro c_soft_red make_colour_rgb(143,37,46)
#macro c_soft_green make_colour_rgb(45,120,47)
#macro c_soft_yellow make_colour_rgb(217,149,58)
#macro c_soft_yellow_dark make_colour_rgb(154,120,73)

#endregion

#region enums

enum ATTACK_SHAPES {
	as_line,
	as_burst,
	as_cone,
	as_blast,
	as_wall
}

enum UNIT_STATES {
	idle,
	moving,
	attacking,
	hurt,
	dodging,
	dying

}

enum WEATHER_STATES {
	present,
	fading
}

enum BUILDING_STATES {
	ready,
	exhausted

}

enum DD_PICKER_TYPES{
	colour_picker,
	player_type_picker,
	map_picker


}


#endregion