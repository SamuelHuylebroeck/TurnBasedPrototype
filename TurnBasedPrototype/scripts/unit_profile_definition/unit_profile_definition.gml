//@description ??
function UnitProfile(verbose_name, _max_hp, _base_movement, _base_avoid, _base_armour, _movement_type) constructor{
	self.verbose_name = verbose_name
	self.max_hp = _max_hp
	self.base_movement = _base_movement
	self.movement_type = _movement_type
	self.base_avoid = _base_avoid
	self.base_armour = _base_armour
	
	static Copy = function()
	{
		return new UnitProfile(verbose_name, max_hp, base_movement, base_avoid, base_armour, movement_type)
	}
}


function CompleteUnitStatProfile(unit_profile,attack_stats_profile, weather_profile) constructor
{
	self.unit_profile = unit_profile
	self.attack_stats_profile = attack_stats_profile
	self.weather_profile= weather_profile
}