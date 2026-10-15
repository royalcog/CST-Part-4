var _w = door_x2 - door_x1, _h = door_y2 - door_y1;

// grab the door's pixels off the tiles once
if (door_spr == -1)
{
    var _tm = layer_tilemap_get_id(layer_get_id("Tiles_1"));
    var _s  = surface_create(_w, _h);
    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);
    draw_tilemap(_tm, -door_x1, -door_y1);
    surface_reset_target();
    door_spr  = sprite_create_from_surface(_s, 0, 0, _w, _h, false, false, 0, 0);
    left_spr  = sprite_create_from_surface(_s, 0, 0, _w div 2, _h, false, false, 0, 0);
    right_spr = sprite_create_from_surface(_s, _w div 2, 0, _w - _w div 2, _h, false, false, _w - _w div 2, 0);
    surface_free(_s);
}

if (state == "broken")
{
    // the doorway
    draw_set_alpha(1);
    draw_set_color(open_color);
    draw_roundrect_ext(door_x1 + 1, door_y1 + 1, door_x2 - 1, door_y2, open_radius, open_radius, false);

    // the panels: smashed in, swinging away into the dark
    var _k = min(t / smash_frames, 1);
    if (_k < 1)
    {
        var _e  = 1 - power(1 - _k, 3);
        var _xs = lerp(1, 0.15, _e);
        var _ys = lerp(1, 0.85, _e);
        var _dy = (_h * (1 - _ys)) / 2 + _e * 6;
        var _a  = 1 - _k;
        var _shake = (1 - _k) * 2;
        draw_sprite_ext(left_spr, 0, door_x1 + random_range(-_shake, _shake), door_y1 + _dy, _xs, _ys, _e * 8, c_white, _a);
        draw_sprite_ext(right_spr, 0, door_x2 + random_range(-_shake, _shake), door_y1 + _dy, _xs, _ys, -_e * 8, c_white, _a);
    }
}
else if (state != "idle" && sprite_exists(door_spr))
{
    // still standing for a few frames after the cut, shaking
    draw_sprite(door_spr, 0, door_x1 + random_range(-1, 1), door_y1);
}

// chunks of the door
for (var i = 0; i < array_length(chunks); i++)
{
    var _c = chunks[i];
    var _a = (_c.t < 50) ? 1 : 1 - (_c.t - 50) / 20;
    draw_sprite_general(door_spr, 0, _c.sx, _c.sy, _c.sz, _c.sz, _c.x, _c.y, 1, 1, _c.rot, c_white, c_white, c_white, c_white, _a);
}

// the cut itself
if (state != "idle" && t < cut_frames)
{
    var _k  = t / cut_frames;
    var _cw = cut_width * (1 - _k);
    gpu_set_blendmode(bm_add);
    draw_set_color(c_white);
    draw_set_alpha(0.35 * (1 - _k));
    draw_line_width(cut_x1, cut_y1, cut_x2, cut_y2, _cw * 2.2);
    draw_set_alpha(1 - _k * 0.5);
    draw_line_width(cut_x1, cut_y1, cut_x2, cut_y2, max(_cw, 1));
    gpu_set_blendmode(bm_normal);
}

// white flash over the door when it's hit
if (flash > 0)
{
    gpu_set_blendmode(bm_add);
    draw_set_color(c_white);
    draw_set_alpha(flash * 0.6);
    draw_roundrect_ext(door_x1, door_y1, door_x2, door_y2, open_radius, open_radius, false);
    gpu_set_blendmode(bm_normal);
}
draw_set_alpha(1);
draw_set_color(c_white);