


#macro c_soft_blue make_colour_rgb(46,61,96)
#macro c_soft_red make_colour_rgb(143,37,46)
#macro c_soft_green make_colour_rgb(45,120,47)
#macro c_soft_yellow make_colour_rgb(217,149,58)
#macro c_soft_yellow_dark make_colour_rgb(154,120,73)
#macro c_soft_light_blue make_color_rgb(97,156,165)



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

enum MOVEMENT_TYPES {
	foot,
	flying,
	heavy
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

enum WEATHER_ELEMENTS {
	fire,
	water,
	wind,
	earth
}

enum WEATHER_RELATIONS {
	fizzle,
	overpower,
	detonate,
	refresh
}

enum AI_TURN_CONTROLLER_STATES {
	task_force_management,
	recruitment,
	task_force_execution,
	done
}

enum TASKFORCE_AI_STANCE {
	expanding,
	attacking,
	defending
}

enum TASKFORCE_TYPES
{
	raider,
	attacker,
	defender
}
enum TASKFORCE_STANCES {
	mustering,
	retreating,
	advancing
}

enum OBJECTIVE_TYPES {
	capture,
	kill,
	guard
}

enum TASK_STATES {
	waiting,
	in_progress,
	done
}

enum ACTION_TYPES {
	move,
	move_and_attack,
	move_and_skill
}
	
enum pause_menu_page {
	main,
	settings,
	audio,
	video,
	controls,
	game,
	size
}

enum options_menu_page {
	settings,
	audio,
	video,
	controls,
	game,
	size
}

enum menu_element_types {
	script_runner,
	page_transfer,
	slider,
	shift,
	toggle,
	input,
	size
}

enum menu_supported_resolution
{
	res_3840x2160,
	res_1920x1080,
	res_1600x900,
	res_1536x864,
	res_1440x900,
	res_1366x768,
	res_1024x768,

}

enum gui_sizes
{
	small,
	medium,
	large
}

enum draw_healthbar_condition{
	never,
	damaged_only,
	always
}

enum sound_map_keys{
	select,
	move,
	recruit,
	attack_move,
	action
}
#endregion