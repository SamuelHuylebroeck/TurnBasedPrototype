#region state variables
has_acted_this_round = false;
current_state = UNIT_STATES.idle;

ds_terrain_crossed = ds_map_create()
ds_weather_crossed = ds_map_create()
ds_boons_and_banes = ds_map_create()
#endregion

#region stat constructors
var global_profile;

if(ds_map_exists(global.unit_stat_map, stats_name))
{
	global_profile = ds_map_find_value(global.unit_stat_map, stats_name)
}else{
	global_profile = ds_map_find_value(global.unit_stat_map, "Default")
}
weather_profile = new WeatherProfile(global_profile.weather_profile.verbose_name, global_profile.weather_profile.weather_type, global_profile.weather_profile.weather_duration,global_profile.weather_profile.weather_burst_size, global_profile.weather_profile.weather_element, global_profile.weather_profile.benign,global_profile.weather_profile.weather_sfx)
var attack_animation_profile = new AttackAnimationProfile(stats_animation_hit_frame, sprite_get_speed(animation_attack_sprite), stats_animation_hit_sprite, stats_animation_hit_sprite_hit_frame,stats_attack_sfx, stats_attack_hit_sfx)
attack_profile = new AttackProfile(global_profile.attack_stats_profile.base_damage,global_profile.attack_stats_profile.base_piercing,global_profile.attack_stats_profile.base_accuracy,global_profile.attack_stats_profile.base_shape, global_profile.attack_stats_profile.base_size,global_profile.attack_stats_profile.min_range,global_profile.attack_stats_profile.max_range,attack_animation_profile, weather_profile)
unit_profile = new UnitProfile(global_profile.unit_profile.verbose_name, global_profile.unit_profile.max_hp, global_profile.unit_profile.base_movement,global_profile.unit_profile.base_avoid,global_profile.unit_profile.base_armour, global_profile.unit_profile.movement_type)
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
