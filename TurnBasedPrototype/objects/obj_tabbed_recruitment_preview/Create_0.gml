/// @description ??
ui_x=0
ui_y=0
max_width=32
max_height=32
width=0;
height=0;
initialized = false;
profile = noone
description = "Placeholder"

frame_counter=0;

recruiting_player = noone;

_team_colour = shader_get_uniform(sha_team_colour_blend, "u_team_colour");
_tc_mix = shader_get_uniform(sha_team_colour_blend, "u_mix");

