//@description ??
function UnitProfile(verbose_name, _max_hp, _base_movement, _base_avoid, _base_armour) constructor{
	self.verbose_name = verbose_name
	self.max_hp = _max_hp
	self.base_movement = _base_movement
	self.base_avoid = _base_avoid
	self.base_armour = _base_armour
}

function UnitProfile(unit_profile) constructor{
	self.verbose_name = unit_profile.verbose_name
	self.max_hp = unit_profile.max_hp
	self.base_movement = unit_profile.base_movement
	self.base_avoid = unit_profile.base_avoid
	self.base_armour = unit_profile.base_armour
}

function CompleteUnitProfile(unit_profile,attack_profile, weather_profile)
{
	self.unit_profile = unit_profile
	self.attack_profile = attack_profile
}