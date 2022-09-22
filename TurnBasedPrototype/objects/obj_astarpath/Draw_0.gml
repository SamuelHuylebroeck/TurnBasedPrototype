/// @description ??
var tile_count = ds_list_size(ds_path_tiles);
if(tile_count >0)
{
	var old_color = draw_get_color();
	
	var tW = sprite_get_width(spr_pathfinding_plains)/2
	var tH = sprite_get_height(spr_pathfinding_plains)/2
	var pW = sprite_get_width(spr_pathfinding_path)
	var pH = sprite_get_height(spr_pathfinding_path)
	
	var start_tile = ds_path_tiles[|0]
	var prev_x = start_tile.x +tW 
	var prev_y = start_tile.y +tH 
	
	if(tile_count > 1)
	{
		for(var i = 1; i < tile_count; i++)
		{
			var next_tile = ds_path_tiles[|i]
			

			var sign_w = sign(next_tile.x+tW-prev_x)
			var width = sign_w!=0 ? abs(next_tile.x+tW-prev_x) : sprite_get_width(spr_pathfinding_path);
			
			var sign_h = sign(next_tile.y+tH-prev_y)
			var height = sign_h != 0 ? abs(next_tile.y+tH-prev_y) : sprite_get_height(spr_pathfinding_path);
			
			var orig_x = sign_w == 0 ? prev_x - pW/2 : (sign_w>0?prev_x  : prev_x-width);
			var orig_y = sign_h ==0 ? prev_y - pH/2 : (sign_h>0?prev_y  : prev_y-height);
		
			draw_sprite_stretched(spr_pathfinding_path,0,orig_x,orig_y, width, height)
			
			prev_x = next_tile.x+tW;
			prev_y = next_tile.y+tH;
			draw_sprite_stretched(spr_pathfinding_path,0,prev_x-pW/2,prev_y-pH/2, pW, pH)
		}
		//draw_sprite_stretched(spr_pathfinding_path,0,prev_x, prev_y, sprite_get_width(spr_pathfinding_path)*2,sprite_get_height(spr_pathfinding_path)*2 );
	}
	


	draw_set_color(old_color);
}

