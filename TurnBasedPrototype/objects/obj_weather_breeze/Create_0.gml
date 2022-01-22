/// @description ??
var speed_amount = 1
start_of_turn_boon_bane = new SpeedBoonSlowBane("bb_breeze", BOON_BANE_TYPES.speed_slow, weather_boon_bane_duration, spr_speedup_boon_icon,speed_amount)
contact_boon_bane = start_of_turn_boon_bane
weather_description = ["A gentle breeze speeds up units starting their turn here", "Increases movement by "+string(speed_amount) + " tile for "+string(weather_boon_bane_duration)+ " turns"]