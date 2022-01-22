/// @description ??
var fire_damage = 8
var fire_boon =  new HealingBoonDamageBane("bb_fire", BOON_BANE_TYPES.heal_damage, weather_boon_bane_duration, spr_fire_damage_bane_icon,-1*fire_damage)
start_of_turn_boon_bane = fire_boon
contact_boon_bane = fire_boon
weather_description = ["A fiery blaze enflames units starting their turn in this fire", "Deals "+string(fire_damage) + " per turn for "+string(weather_boon_bane_duration)+ " turns"]