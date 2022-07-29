function WeatherProfile(verbose_name="Placeholder Weather", weather_type= obj_placeholder_weather, weather_duration=3, weather_burst_size=1.5, weather_element=WEATHER_ELEMENTS.wind, benign = true, weather_sfx=snd_unit_generic_action01) constructor
{
	self.verbose_name = verbose_name
	self.weather_type = weather_type
	self.weather_duration = weather_duration
	self.weather_burst_size = weather_burst_size
	self.weather_element = weather_element
	self.benign = benign
	self.weather_sfx = weather_sfx
	
	static Copy = function()
	{
		return new WeatherProfile(verbose_name, weather_type, weather_duration, weather_burst_size, weather_element,benign,weather_sfx)
	}
}