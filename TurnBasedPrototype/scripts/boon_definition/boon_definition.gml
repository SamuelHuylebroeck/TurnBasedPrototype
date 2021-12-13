//@description ??
function AbstractBoonBane(verbose_name, bb_type, duration, icon_sprite) constructor{
	self.verbose_name = verbose_name
	self.bb_type = bb_type
	self.duration = duration
	self.current_duration = duration
	self.icon_sprite = icon_sprite
	
	static Apply = function(unit){
		show_debug_message("Applying abstract boon or bane")
		duration--;
		return duration <= 0
	}
}

function AbstractBoonBaneCopy(boon_bane) constructor {
	self.verbose_name = boon_bane.verbose_name
	self.bb_type = boon_bane.bb_type
	self.duration = boon_bane.duration
	self.current_duration = boon_bane.current_duration
	self.icon_sprite = boon_bane.icon_sprite
	
	static Apply = function(unit){
		show_debug_message("Applying abstract boon or bane")
		duration--;
		return duration <= 0
	}
}

function HealingBoonDamageBane(verbose_name,bb_type, duration,icon_sprite, hp_change) : AbstractBoonBane(verbose_name, bb_type, duration,icon_sprite) constructor{
	self.hp_change = hp_change
	
	static Apply = function(unit){
		show_debug_message("Applying healing boon or damage bane")
		do_hp_change(unit, hp_change)
		duration--;
		return duration <= 0
	}	
}

function HealingBoonDamageBaneCopy(boon_bane) : AbstractBoonBaneCopy(boon_bane) constructor{
	self.hp_change = boon_bane.hp_change
	
	static Apply = function(unit){
		show_debug_message("Applying healing boon or damage bane")
		do_hp_change(unit, hp_change)
		duration--;
		return duration <= 0
	}	
}

function SpeedBoonSlowBane(verbose_name, bb_type, duration, icon_sprite, speed_change) : AbstractBoonBane(verbose_name, bb_type, duration,icon_sprite) constructor{
	self.speed_change = speed_change
	
	static Apply = function(unit){
		show_debug_message("Applying speed boon or slow bane")
		unit.move_points_total_current += self.speed_change
		duration--;
		return duration <= 0
	}	
}

function SpeedBoonSlowBaneCopy(boon_bane) : AbstractBoonBaneCopy(boon_bane) constructor{
	self.speed_change = boon_bane.speed_change
	
	static Apply = function(unit){
		show_debug_message("Applying speed boon or slow bane")
		unit.move_points_total_current += self.speed_change
		duration--;
		return duration <= 0
	}	
}

