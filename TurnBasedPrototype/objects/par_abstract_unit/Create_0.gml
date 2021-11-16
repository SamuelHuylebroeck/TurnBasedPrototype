#region state variables
has_acted_this_round = false;
is_moving = false;
#endregion

#region derived stats
//Derived stats
move_points_pixels = stats_move_points_grid * global.grid_cell_width;
move_points_pixels_curr = move_points_pixels;
#endregion

#region shaders
_team_colour = shader_get_uniform(sha_team_colour_blend, "u_team_colour");
_tc_mix = shader_get_uniform(sha_team_colour_blend, "u_mix")
#endregion