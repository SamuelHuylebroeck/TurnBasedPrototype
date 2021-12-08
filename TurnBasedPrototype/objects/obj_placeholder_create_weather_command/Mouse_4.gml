/// @description Initiate create weather
clean_up_create_weather_preview()
var weather_orchestrator = instance_create_layer(x,y,"Units",obj_create_weather_orchestrator)
with(weather_orchestrator){
	linked_unit = other.linked_unit
	linked_weather_profile = other.linked_weather_profile
	alarm[0]=1
}
instance_destroy()