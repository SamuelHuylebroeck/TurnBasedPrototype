//@description ??
function draw_attack_preview(attack_profile, target_unit, origin_unit){
	var old_color = draw_get_color()
	var old_font = draw_get_font()
	var old_halign = draw_get_halign()
	var simulation_result = simulate_attack(attack_profile, target_unit,origin_unit)
	#region health bar
	var hb_width = 48
	var hb_heigth = 8
	var tl_x= x-hb_width/2
	var tl_y= y+global.grid_cell_height/2-hb_heigth
	draw_set_color(c_red)
	draw_rectangle(tl_x,tl_y, tl_x+hb_width, tl_y+hb_heigth, false)
	draw_set_color(c_green)
	var rel_health_remaining=  clamp(target_unit.current_hp/target_unit.unit_profile.max_hp,0,1)
	draw_rectangle(tl_x,tl_y, tl_x+rel_health_remaining*hb_width, tl_y+hb_heigth, false)
	
	var health_after_attack = max(target_unit.current_hp - simulation_result.damage,0)
	var rel_health_after_attack = clamp(health_after_attack/target_unit.unit_profile.max_hp,0,1)
	counter = (counter+1)%counter_max
	var merge_value = counter/counter_max
	var sine_curve = animcurve_get(ac_sine)
	var channel = animcurve_get_channel(sine_curve,"sine" )
	var curve_pos = animcurve_channel_evaluate(channel, merge_value)
	var colour = merge_color(c_yellow,c_white,curve_pos)
	draw_set_color(colour)
	draw_rectangle(tl_x+rel_health_after_attack*hb_width,tl_y, tl_x+rel_health_remaining*hb_width, tl_y+hb_heigth, false)
	
	#endregion health bar
	#region hit rate
	var hit_rate = floor(simulation_result.hit_rate)
	var hit_rate_text = string(hit_rate)+"%"
	draw_set_font(font_attack_preview)
	var hit_rate_width = string_length(hit_rate_text)
	draw_set_halign(fa_center)
	draw_set_color(c_soft_yellow)
	draw_text(x-hit_rate_width/2,y-global.grid_cell_width/2,hit_rate_text)
	#endregion hit rate
	draw_set_color(old_color)
	draw_set_font(old_font)
	draw_set_halign(old_halign)
}

function simulate_attack(attack_profile, target_unit, origin_unit){
	#region return components
	// Hit rate
	// Damage
	// Kill or not
	// Terrain reaction
	// Terrain after attack
	#endregion
	var refined_profile = get_refined_stats(attack_profile, origin_unit, target_unit)
	var kills = (target_unit.current_hp- refined_profile.d) <=0
	var result={
		hit_rate: refined_profile.hr,
		damage: refined_profile.d,
		kill: kills,
		terrain_reaction: WEATHER_RELATIONS.overpower,
		terrain_after_attack: obj_weather_fire
	}
	return result
}