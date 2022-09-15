/// @description ??
var tile_count = ds_list_size(ds_path_tiles);
if(tile_count >0)
{
	var old_color = draw_get_color();
	
	var w = sprite_get_width(spr_pathfinding_plains)/2
	var h = sprite_get_height(spr_pathfinding_plains)/2
	
	var start_tile = ds_path_tiles[|0]
	var prev_x = start_tile.x +w 
	var prev_y = start_tile.y +h 
	

	draw_set_color(c_blue)
	draw_circle(prev_x, prev_y, 8, false);
	
	if(tile_count > 1)
	{
		for(var i = 1; i < tile_count; i++)
		{
			var next_tile = ds_path_tiles[|i]
			
			draw_line_width(prev_x, prev_y , next_tile.x+w, next_tile.y+h, 4);
			
			prev_x = next_tile.x+w;
			prev_y = next_tile.y+h;
		}
		draw_rectangle(prev_x -4, prev_y-4, prev_x+4, prev_y+4, false);
	}
	


	draw_set_color(old_color);
}

