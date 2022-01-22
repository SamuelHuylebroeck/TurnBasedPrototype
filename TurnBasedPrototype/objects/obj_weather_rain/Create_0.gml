/// @description ??
var rain_heal = 5
start_of_turn_boon_bane = new HealingBoonDamageBane("bb_rain", BOON_BANE_TYPES.heal_damage, weather_boon_bane_duration, spr_rain_healing_boon_icon,rain_heal)
contact_boon_bane = start_of_turn_boon_bane
weather_description = ["Soothing rain that heals units starting their turn here", "Heals "+string(rain_heal) + " per turn for "+string(weather_boon_bane_duration)+ " turns"]