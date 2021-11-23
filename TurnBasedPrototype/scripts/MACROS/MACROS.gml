
#region colour definitions

#macro c_soft_blue make_colour_rgb(46,61,96)
#macro c_soft_red make_colour_rgb(143,37,46)
#macro c_soft_green make_colour_rgb(45,120,47)
#macro c_soft_yellow make_colour_rgb(217,149,58)

#endregion

#region enums

enum ATTACK_SHAPES {
	as_line,
	as_burst,
	as_cone,
	as_blast
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

#endregion