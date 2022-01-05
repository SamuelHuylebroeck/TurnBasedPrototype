/// @description ??
draw_self()
var unit_under_tile = instance_position(x,y,par_abstract_unit)
if unit_under_tile != noone {
	draw_attack_preview(linked_attack_profile,unit_under_tile,linked_attacker)
}