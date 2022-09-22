//@description ??
function define_unit_stat_map()
{
	global.unit_stat_map = ds_map_create()
	//default
	var defaultWeatherProfile = new WeatherProfile("Weather", obj_placeholder_weather, 3,2,WEATHER_ELEMENTS.wind, true, snd_unit_generic_action01)
	var defaultAttackProfile = new AttackStatsProfile(5,0,90,ATTACK_SHAPES.as_line,3,1,2,defaultWeatherProfile)
	var defaultUnitProfile= new UnitProfile("Placeholder", 10,5,0,0, MOVEMENT_TYPES.foot)
	var defaultCompleteProfile = new CompleteUnitStatProfile(defaultUnitProfile, defaultAttackProfile, defaultWeatherProfile)
	ds_map_add(global.unit_stat_map,"Default", defaultCompleteProfile)
	
	add_infantry_stats(global.unit_stat_map)
	add_heavy_stats(global.unit_stat_map)
	add_archer_stats(global.unit_stat_map)
	
}

function add_infantry_stats(ds_stat_map)
{
	#region flamesword
	var flameswordWeatherProfile = new WeatherProfile("Fire", obj_weather_fire, 4,1.5,WEATHER_ELEMENTS.fire, false, snd_unit_generic_action01)
	var flameswordAttackProfile = new AttackStatsProfile(23,0,100,ATTACK_SHAPES.as_cone,2,1,1,flameswordWeatherProfile)
	var flameswordUnitProfile= new UnitProfile("Flamesword", 65,4,15,5, MOVEMENT_TYPES.foot)
	var flameswordCompleteProfile = new CompleteUnitStatProfile(flameswordUnitProfile, flameswordAttackProfile, flameswordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Flamesword", flameswordCompleteProfile)
	#endregion
	
	#region windsword
	var windswordWeatherProfile = new WeatherProfile("Breeze", obj_weather_breeze, 3,1.5,WEATHER_ELEMENTS.wind, true, snd_unit_generic_action01)
	var windswordAttackProfile = new AttackStatsProfile(20,15,90,ATTACK_SHAPES.as_line,3,1,1,windswordWeatherProfile)
	var windswordUnitProfile= new UnitProfile("Windsword", 50,5,40,3, MOVEMENT_TYPES.foot)
	var windswordCompleteProfile = new CompleteUnitStatProfile(windswordUnitProfile, windswordAttackProfile, windswordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Windsword", windswordCompleteProfile)
	#endregion
	
	#region groundpounder
	var groundpounderWeatherProfile = new WeatherProfile("Cover", obj_weather_cover, 2,1,WEATHER_ELEMENTS.earth, true, snd_unit_generic_action01)
	var groundpounderAttackProfile = new AttackStatsProfile(22,5,90,ATTACK_SHAPES.as_blast,1,2,2,groundpounderWeatherProfile)
	var groundpounderUnitProfile= new UnitProfile("Groundpounder", 75,4,15,10, MOVEMENT_TYPES.heavy)
	var groundpounderCompleteProfile = new CompleteUnitStatProfile(groundpounderUnitProfile, groundpounderAttackProfile, groundpounderWeatherProfile)
	ds_map_add(global.unit_stat_map,"Groundpounder", groundpounderCompleteProfile)
	#endregion
	
	#region waveaxe
	var waveaxeWeatherProfile = new WeatherProfile("Healing Rain", obj_weather_rain, 3,2,WEATHER_ELEMENTS.water, true, snd_unit_generic_action01)
	var waveaxeAttackProfile = new AttackStatsProfile(18,7,120,ATTACK_SHAPES.as_wall,2,1,2,waveaxeWeatherProfile)
	var waveaxeUnitProfile= new UnitProfile("Wave Axe", 90,4,20,8, MOVEMENT_TYPES.foot)
	var waveaxeCompleteProfile = new CompleteUnitStatProfile(waveaxeUnitProfile, waveaxeAttackProfile, waveaxeWeatherProfile)
	ds_map_add(global.unit_stat_map,"Wave Axe", waveaxeCompleteProfile)
	#endregion
}


function add_heavy_stats(ds_stat_map)
{
	#region Forgelord
	var forgelordWeatherProfile = new WeatherProfile("Heat Haze", obj_weather_heat_haze, 2,2,WEATHER_ELEMENTS.fire, false, snd_unit_generic_action01)
	var forgelordAttackProfile = new AttackStatsProfile(35,0,90,ATTACK_SHAPES.as_burst,2,1,2,forgelordWeatherProfile)
	var forgelordUnitProfile= new UnitProfile("Forgelord", 120,3,5,18, MOVEMENT_TYPES.heavy)
	var forgelordCompleteProfile = new CompleteUnitStatProfile(forgelordUnitProfile, forgelordAttackProfile, forgelordWeatherProfile)
	ds_map_add(global.unit_stat_map,"Forgelord", forgelordCompleteProfile)
	#endregion
	
	#region Tempest Knight
	var tempestknightWeatherProfile = new WeatherProfile("Charged Ground", obj_weather_charged_zone, 1,1.5,WEATHER_ELEMENTS.wind, false, snd_unit_generic_action01)
	var tempestknightAttackProfile = new AttackStatsProfile(28,15,90,ATTACK_SHAPES.as_blast,2,1,2,tempestknightWeatherProfile)
	var tempestknightUnitProfile= new UnitProfile("Tempest Knight", 100,4,15,12, MOVEMENT_TYPES.foot)
	var tempestknightCompleteProfile = new CompleteUnitStatProfile(tempestknightUnitProfile, tempestknightAttackProfile, tempestknightWeatherProfile)
	ds_map_add(global.unit_stat_map,"Tempest Knight", tempestknightCompleteProfile)
	#endregion
	
	#region Groundsplitter
	var groundsplitterWeatherProfile = new WeatherProfile("Cover", obj_weather_cover, 3,2,WEATHER_ELEMENTS.earth, true, snd_unit_generic_action01)
	var groundsplitterAttackProfile = new AttackStatsProfile(23,5,90,ATTACK_SHAPES.as_wall,2,1,1,groundsplitterWeatherProfile)
	var groundsplitterUnitProfile= new UnitProfile("Groundsplitter", 120,2,5,18, MOVEMENT_TYPES.heavy)
	var groundsplitterCompleteProfile = new CompleteUnitStatProfile(groundsplitterUnitProfile, groundsplitterAttackProfile, groundsplitterWeatherProfile)
	ds_map_add(global.unit_stat_map,"Groundsplitter", groundsplitterCompleteProfile)
	#endregion
	
	#region Captain
	var captainWeatherProfile = new WeatherProfile("Healing Rain", obj_weather_rain, 3,2,WEATHER_ELEMENTS.water, true, snd_unit_generic_action01)
	var captainAttackProfile = new AttackStatsProfile(28,7,100,ATTACK_SHAPES.as_cone,3,1,1,captainWeatherProfile)
	var captainUnitProfile= new UnitProfile("Captain Knight", 120,4,10,12, MOVEMENT_TYPES.heavy)
	var captainCompleteProfile = new CompleteUnitStatProfile(captainUnitProfile, captainAttackProfile, captainWeatherProfile)
	ds_map_add(global.unit_stat_map,"Captain Knight", captainCompleteProfile)
	#endregion

}

function add_archer_stats(ds_stat_map)
{
	#region Pyro Archer
	var pyroArcherWeatherProfile = new WeatherProfile("Fire", obj_weather_fire, 4,1.5,WEATHER_ELEMENTS.fire, false, snd_unit_generic_action01)
	var pyroArcherAttackProfile = new AttackStatsProfile(28,0,90,ATTACK_SHAPES.as_blast,2,2,4,pyroArcherWeatherProfile)
	var pyroArcherUnitProfile= new UnitProfile("Pyro Archer", 50,3,20,3, MOVEMENT_TYPES.foot)
	var pyroArcherCompleteProfile = new CompleteUnitStatProfile(pyroArcherUnitProfile, pyroArcherAttackProfile, pyroArcherWeatherProfile)
	ds_map_add(global.unit_stat_map,"Pyro Archer", pyroArcherCompleteProfile)
	#endregion
	
	#region Pyro Archer
	var boltThrowerWeatherProfile = new WeatherProfile("Charged Ground", obj_weather_charged_zone, 2,1,WEATHER_ELEMENTS.wind, false, snd_unit_generic_action01)
	var boltThrowerAttackProfile = new AttackStatsProfile(35,15,90,ATTACK_SHAPES.as_wall,2,2,5,boltThrowerWeatherProfile)
	var boltThrowerUnitProfile= new UnitProfile("Bolt Thrower", 50,4,20,3, MOVEMENT_TYPES.foot)
	var boltThrowerCompleteProfile = new CompleteUnitStatProfile(boltThrowerUnitProfile, boltThrowerAttackProfile, boltThrowerWeatherProfile)
	ds_map_add(global.unit_stat_map,"Bolt Thrower", boltThrowerCompleteProfile)
	#endregion
	
	#region Shard Slinger
	var shardSlingerWeatherProfile = new WeatherProfile("Unsteady Ground", obj_weather_unsteady_ground, 2,2,WEATHER_ELEMENTS.earth, false, snd_unit_generic_action01)
	var shardSlingerAttackProfile = new AttackStatsProfile(18,5,80,ATTACK_SHAPES.as_line,2,2,2,shardSlingerWeatherProfile)
	var shardSlingerUnitProfile= new UnitProfile("Shard Slinger", 60,3,15,5, MOVEMENT_TYPES.foot)
	var shardSlingerCompleteProfile = new CompleteUnitStatProfile(shardSlingerUnitProfile, shardSlingerAttackProfile, shardSlingerWeatherProfile)
	ds_map_add(global.unit_stat_map,"Shard Slinger", shardSlingerCompleteProfile)
	#endregion
	
	#region Marine Archer
	var marineArcherWeatherProfile = new WeatherProfile("Brittling Frost", obj_weather_chillzone,2,1,WEATHER_ELEMENTS.water, false, snd_unit_generic_action01)
	var marineArcherAttackProfile = new AttackStatsProfile(18,7,110,ATTACK_SHAPES.as_blast,1,2,3,marineArcherWeatherProfile)
	var marineArcherUnitProfile= new UnitProfile("Marine Archer", 65,4,40,5, MOVEMENT_TYPES.foot)
	var marineArcherCompleteProfile = new CompleteUnitStatProfile(marineArcherUnitProfile, marineArcherAttackProfile, marineArcherWeatherProfile)
	ds_map_add(global.unit_stat_map,"Marine Archer", marineArcherCompleteProfile)
	#endregion
}