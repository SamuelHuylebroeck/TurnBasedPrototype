#region state variables
has_acted_this_round = false;
current_state = UNIT_STATES.idle;

ds_terrain_crossed = ds_map_create()
ds_weather_crossed = ds_map_create()
ds_boons_and_banes = ds_map_create()
#endregion

#region stat constructors
weather_profile = new WeatherProfile(stats_weather_name, stats_weather_template, stats_weather_duration,stats_weather_burst_size, stats_weather_element, stats_weather_benign,stats_weather_sfx)
var attack_animation_profile = new AttackAnimationProfile(stats_animation_hit_frame, sprite_get_speed(animation_attack_sprite), stats_animation_hit_sprite, stats_animation_hit_sprite_hit_frame,stats_attack_sfx, stats_attack_hit_sfx)
attack_profile = new AttackProfile(stats_damage,stats_piercing,stats_accuracy,stats_attack_shape, stats_attack_size,stats_attack_min_range,stats_attack_max_range,attack_animation_profile, weather_profile)
unit_profile = new UnitProfile(stats_name, stats_hp, stats_move_points_grid,stats_avoid,stats_armour)
unit_sound_map = get_unit_sound_map(stats_sound_map_key)
#endregion

#region derived stats

current_hp = unit_profile.max_hp

move_points_total_current = unit_profile.base_movement;

refresh_movement(self)

animation_sprites[UNIT_STATES.idle]= animation_idle_sprite
animation_sprites[UNIT_STATES.attacking]= animation_attack_sprite
animation_sprites[UNIT_STATES.hurt]=animation_hurt_sprite
animation_sprites[UNIT_STATES.moving]=animation_movement_sprite
animation_sprites[UNIT_STATES.dying]=animation_dying_sprite
#endregion

#region shaders
_team_colour = shader_get_uniform(sha_team_colour_blend, "u_team_colour");
_tc_mix = shader_get_uniform(sha_team_colour_blend, "u_mix");
_highlight_colour=shader_get_uniform(sha_team_colour_blend, "u_highlight_colour");
_highlight_mix=shader_get_uniform(sha_team_colour_blend, "u_highlight_mix");
#endregion
