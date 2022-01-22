/// @description ??
var slow_amount = 2
start_of_turn_boon_bane = new SpeedBoonSlowBane("bb_unsteady_ground", BOON_BANE_TYPES.speed_slow, weather_boon_bane_duration, spr_speedup_boon_icon,-1*slow_amount)
contact_boon_bane = start_of_turn_boon_bane
weather_description = ["Rough terrain slows units starting their turn here", "Slows movement by "+string(slow_amount) + " tile for "+string(weather_boon_bane_duration)+ " turns"]