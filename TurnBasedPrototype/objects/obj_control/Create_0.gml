/// @description ??
init_globals()
global.selected = noone;
global.enemy_selected = noone;
global.moving = false;
global.combat_animation_playing = false;
global.game_in_progress = false;

ds_gui_elements = ds_list_create();
move_grid_drawn = false;

ds_turn_order = ds_list_create()
current_active_player_index = 0