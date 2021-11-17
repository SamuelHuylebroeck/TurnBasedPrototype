#region state variables
has_acted_this_round = false;
current_state = UNIT_STATES.idle
#endregion

#region derived stats
//Derived stats
move_points_pixels = stats_move_points_grid * global.grid_cell_width;
move_points_pixels_curr = move_points_pixels;

animation_sprites[UNIT_STATES.idle]= animation_idle_sprite
animation_sprites[UNIT_STATES.attacking]= animation_attack_sprite
animation_sprites[UNIT_STATES.hurt]=animation_hurt_sprite
animation_sprites[UNIT_STATES.moving]=animation_movement_sprite
#endregion

#region shaders
_team_colour = shader_get_uniform(sha_team_colour_blend, "u_team_colour");
_tc_mix = shader_get_uniform(sha_team_colour_blend, "u_mix")
#endregion

#region stat constructors
var attack_animation_profile = new AttackAnimationProfile(7, sprite_get_speed(animation_sprites[UNIT_STATES.attacking]))
attack_profile = new AttackProfile(5,1,90,ATTACK_SHAPES.as_line, 3,1,1,attack_animation_profile)
unit_profile = new UnitProfile(50, stats_move_points_grid,10,2)
#endregion