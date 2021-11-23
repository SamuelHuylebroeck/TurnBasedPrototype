                                                                  //@description ??
function AttackProfile(base_damage=5, base_piercing=0,base_accuracy=90,base_shape=ATTACK_SHAPES.as_line, base_size=3,min_range=1, max_range=2, animation_profile = new AttackAnimationProfile(), weather_profile= new WeatherProfile()) constructor
{
	self.base_damage = base_damage;
	self.base_piercing = base_piercing;
	self.base_accuracy = base_accuracy;
	self.base_shape= base_shape;
	self.base_size = base_size;
	self.min_range = min_range;
	self.max_range = max_range;
	self.animation_profile = animation_profile;
	self.weather_profile = weather_profile;

}

function AttackAnimationProfile(hit_frame=0, base_sprite_animation_speed=1) constructor
{
	self.hit_frame = hit_frame
	self.base_sprite_animation_speed = base_sprite_animation_speed
}
