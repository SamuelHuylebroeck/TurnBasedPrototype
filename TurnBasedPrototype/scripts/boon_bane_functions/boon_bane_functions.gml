//@description ??
function duplicate_boon_bane(boon_bane){
	var copy;
	switch(boon_bane.bb_type){
		case BOON_BANE_TYPES.heal_damage:
		    copy = new HealingBoonDamageBaneCopy(boon_bane)
			return copy;
		case BOON_BANE_TYPES.speed_slow:
		    copy = new SpeedBoonSlowBaneCopy(boon_bane)
			return copy;
		default:
			return noone
	
	}
}


enum BOON_BANE_TYPES{
	heal_damage,
	speed_slow

}