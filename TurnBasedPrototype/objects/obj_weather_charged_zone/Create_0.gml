/// @description ??
var lightning_damage = 15
var lightning_boon =  new HealingBoonDamageBane("bb_lightning", BOON_BANE_TYPES.heal_damage, weather_boon_bane_duration, spr_fire_damage_bane_icon,-1*lightning_damage)
start_of_turn_boon_bane = lightning_boon
contact_boon_bane = lightning_boon
weather_description = ["Electricity courses across the ground", "Deals "+string(lightning_damage) + " per turn for "+string(weather_boon_bane_duration)+ " turns"]


start_of_turn_boon_bane = new HealingBoonDamageBane("p_lightning", BOON_BANE_TYPES.heal_damage, 1, spr_fire_damage_bane_icon,15)