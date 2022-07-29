//@description ??
function define_unit_stat_map()
{
	global.unit_stat_map = ds_map_create()
	//default
	var defaultWeatherProfile = new WeatherProfile("Weather", obj_placeholder_weather, 3,2,WEATHER_ELEMENTS.wind, true, snd_unit_generic_action01)
	var defaultAttackProfile = new AttackStatsProfile(5,0,90,ATTACK_SHAPES.as_line,3,1,2,defaultWeatherProfile)
	var defaultUnitProfile= new UnitProfile("Placeholder", 10,5,0,0)
	var defaultCompleteProfile = new CompleteUnitStatProfile(defaultUnitProfile, defaultAttackProfile, defaultWeatherProfile)
	ds_map_add(global.unit_stat_map,"Default", defaultCompleteProfile)
	
	add_infantry_stats(global.unit_stat_map)
	add_heavy_stats(global.unit_stat_map)
	add_archer_stats(global.unit_stat_map)
	
}

function add_infantry_stats(ds_stat_map)
{
	#region flamesword
	var flameswordWeatherProfile = new WeatherProfile("Fire", obj_weather_fire, 3,1.5,WEATHER_ELEMENTS.fire, false, snd_unit_generic_action01)
	var flameswordAttackProfile = new AttackStatsProfile(21,3,100,ATTACK_SHAPES.as_cone,2,1,1,flameswordWeatherProfile)
	var flameswordUnitProfile= new UnitProfile("Flamesword", 50,5,0,5)
	var flameswordCompleteProfile = new CompleteUnitStatProfile(flameswordUnitProfile, flameswordAttackProfile, flameswordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Flamesword", flameswordCompleteProfile)
	#endregion
	
	#region windsword
	var windswordWeatherProfile = new WeatherProfile("Breeze", obj_weather_breeze, 3,1.5,WEATHER_ELEMENTS.wind, true, snd_unit_generic_action01)
	var windswordAttackProfile = new AttackStatsProfile(15,12,85,ATTACK_SHAPES.as_line,3,1,1,windswordWeatherProfile)
	var windswordUnitProfile= new UnitProfile("Windsword", 30,6,30,5)
	var windswordCompleteProfile = new CompleteUnitStatProfile(windswordUnitProfile, windswordAttackProfile, windswordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Windsword", windswordCompleteProfile)
	#endregion
	
	#region groundpounder
	var groundpounderWeatherProfile = new WeatherProfile("Rough Ground", obj_weather_unsteady_ground, 3,1.5,WEATHER_ELEMENTS.earth, false, snd_unit_generic_action01)
	var groundpounderAttackProfile = new AttackStatsProfile(18,6,85,ATTACK_SHAPES.as_blast,1,1,2,groundpounderWeatherProfile)
	var groundpounderUnitProfile= new UnitProfile("Groundpounder", 60,3,0,14)
	var groundpounderCompleteProfile = new CompleteUnitStatProfile(groundpounderUnitProfile, groundpounderAttackProfile, groundpounderWeatherProfile)
	ds_map_add(global.unit_stat_map,"Groundpounder", groundpounderCompleteProfile)
	#endregion
	
	#region waveaxe
	var waveaxeWeatherProfile = new WeatherProfile("Rain", obj_weather_rain, 3,1.5,WEATHER_ELEMENTS.water, true, snd_unit_generic_action01)
	var waveaxeAttackProfile = new AttackStatsProfile(15,9,85,ATTACK_SHAPES.as_burst,1,1,1,waveaxeWeatherProfile)
	var waveaxeUnitProfile= new UnitProfile("Wave Axe", 70,4,15,8)
	var waveaxeCompleteProfile = new CompleteUnitStatProfile(waveaxeUnitProfile, waveaxeAttackProfile, waveaxeWeatherProfile)
	ds_map_add(global.unit_stat_map,"Wave Axe", waveaxeCompleteProfile)
	#endregion
}


function add_heavy_stats(ds_stat_map)
{
	#region Forgelord
	var forgelordWeatherProfile = new WeatherProfile("Fire", obj_weather_fire, 3,2,WEATHER_ELEMENTS.fire, false, snd_unit_generic_action01)
	var forgelordAttackProfile = new AttackStatsProfile(38,0,75,ATTACK_SHAPES.as_burst,2,1,1,forgelordWeatherProfile)
	var forgelordUnitProfile= new UnitProfile("Forgelord", 100,3,10,5)
	var forgelordCompleteProfile = new CompleteUnitStatProfile(forgelordUnitProfile, forgelordAttackProfile, forgelordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Forgelord", forgelordCompleteProfile)
	#endregion
	
	#region Tempest Knight
	var tempestknightWeatherProfile = new WeatherProfile("Breeze", obj_weather_breeze, 3,2,WEATHER_ELEMENTS.wind, true, snd_unit_generic_action01)
	var tempestknightAttackProfile = new AttackStatsProfile(25,18,85,ATTACK_SHAPES.as_blast,2,1,2,tempestknightWeatherProfile)
	var tempestknightUnitProfile= new UnitProfile("Tempest Knight", 80,4,10,10)
	var tempestknightCompleteProfile = new CompleteUnitStatProfile(tempestknightUnitProfile, tempestknightAttackProfile, tempestknightWeatherProfile)
	ds_map_add(global.unit_stat_map,"Tempest Knight", tempestknightCompleteProfile)
	#endregion
	
	#region Groundsplitter
	var groundsplitterWeatherProfile = new WeatherProfile("Unsteady Ground", obj_weather_unsteady_ground, 3,2,WEATHER_ELEMENTS.earth, false, snd_unit_generic_action01)
	var groundsplitterAttackProfile = new AttackStatsProfile(26,6,85,ATTACK_SHAPES.as_line,2,1,1,groundsplitterWeatherProfile)
	var groundsplitterUnitProfile= new UnitProfile("Groundsplitter", 120,2,5,12)
	var groundsplitterCompleteProfile = new CompleteUnitStatProfile(groundsplitterUnitProfile, groundsplitterAttackProfile, groundsplitterWeatherProfile)
	ds_map_add(global.unit_stat_map,"Groundsplitter", groundsplitterCompleteProfile)
	#endregion
	
	#region Captain
	var captainWeatherProfile = new WeatherProfile("Rain", obj_weather_rain, 3,2,WEATHER_ELEMENTS.water, true, snd_unit_generic_action01)
	var captainAttackProfile = new AttackStatsProfile(26,6,85,ATTACK_SHAPES.as_cone,2,1,1,captainWeatherProfile)
	var captainUnitProfile= new UnitProfile("Captain Knight", 50,5,0,5)
	var captainCompleteProfile = new CompleteUnitStatProfile(captainUnitProfile, captainAttackProfile, captainWeatherProfile)
	ds_map_add(global.unit_stat_map,"Captain Knight", captainCompleteProfile)
	#endregion

}

function add_archer_stats(ds_stat_map)
{
	#region Marine Archer
	var marineArcherWeatherProfile = new WeatherProfile("Rain", obj_weather_rain, 3,1.5,WEATHER_ELEMENTS.water, true, snd_unit_generic_action01)
	var marineArcherAttackProfile = new AttackStatsProfile(21,3,100,ATTACK_SHAPES.as_blast,1,2,3,marineArcherWeatherProfile)
	var marineArcherUnitProfile= new UnitProfile("Marine Archer", 50,5,0,5)
	var marineArcherCompleteProfile = new CompleteUnitStatProfile(marineArcherUnitProfile, marineArcherAttackProfile, marineArcherWeatherProfile)
	ds_map_add(global.unit_stat_map,"Marine Archer", marineArcherCompleteProfile)
	#endregion
}