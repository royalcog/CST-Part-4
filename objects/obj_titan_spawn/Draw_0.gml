var _vt = camera_get_view_y(view_camera[0]) - 20;
var _vb = _vt + camera_get_view_height(view_camera[0]) + 40;

// the pool: black, with the white flash fading off it
if (show_pool && !show_burst && !show_geyser)
    draw_pool(spr_titan_fountain_burst_base, 0, 1);
if (pool_white > 0)
    draw_pool(spr_titan_fountain_loop_base_white, 0, pool_white);

// the burst
if (show_burst)
{
    var _i = clamp(floor(frame), 0, sprite_get_number(spr_titan_fountain_burst) - 1);
    draw_pool(spr_titan_fountain_burst_base, _i, 1);
    draw_pool(spr_titan_fountain_burst, _i, 1);
}

// the geyser, all the way up the screen
if (show_geyser)
{
    var _li = floor(loop_frame);
    draw_pool(spr_titan_fountain_loop_base, _li mod sprite_get_number(spr_titan_fountain_loop_base), 1);
    draw_column(spr_titan_fountain_loop, _li mod sprite_get_number(spr_titan_fountain_loop), base_bottom_y, _vt, _vb);
    draw_pool(spr_titan_fountain_loop_rings, _li mod sprite_get_number(spr_titan_fountain_loop_rings), 1);
}

if (petrified)
{
    // the dark shell, above the crack, all the way up the screen
    var _bot = min(front_y, _vb);
    if (_bot > _vt)
    {
        draw_set_color(c_black);
        draw_rectangle(fx - pillar_half, _vt, fx + pillar_half, _bot, false);

        var _th = sprite_get_height(spr_fountain) * dark_scale;
        draw_column(spr_fountain, 0, base_bottom_y + _th - (dark_scroll mod _th), _vt, _bot, dark_scale, dark_col, 1);
        gpu_set_blendmode(bm_add);
        draw_column(spr_fountain, 0, base_bottom_y + _th - ((dark_scroll2 + _th / 3) mod _th), _vt, _bot, dark_scale, dark_col2, dark_layer2_alpha);
        gpu_set_blendmode(bm_normal);
    }

    // the grey stone, below the crack
    var _gt = max(front_y, _vt);
    var _gb = min(base_bottom_y, _vb);
    if (_gb > _gt)
    {
        draw_column(spr_titantower_piece,    0, base_bottom_y, _gt, _gb, tower_scale);
        draw_column(spr_titantower_gradient, 0, base_bottom_y, _gt, _gb, tower_scale);
    }

    // the last thin bit of the geyser, shrinking away
    if (cyan_line > 0)
    {
        var _lw = cyan_line_w * cyan_line / 2;
        draw_set_color(make_color_rgb(0, 230, 255));
        draw_rectangle(fx - _lw, _vt, fx + _lw, min(front_y, _vb), false);
    }
}

// chunks of the shell
if (array_length(debris) > 0)
{
    draw_primitive_begin(pr_trianglelist);
    for (var i = 0; i < array_length(debris); i++)
    {
        var _d = debris[i];
        draw_vertex_color(_d.x + lengthdir_x(_d.r1, _d.rot),       _d.y + lengthdir_y(_d.r1, _d.rot),       _d.col, _d.alpha);
        draw_vertex_color(_d.x + lengthdir_x(_d.r2, _d.rot + 125), _d.y + lengthdir_y(_d.r2, _d.rot + 125), _d.col, _d.alpha);
        draw_vertex_color(_d.x + lengthdir_x(_d.r3, _d.rot + 235), _d.y + lengthdir_y(_d.r3, _d.rot + 235), _d.col, _d.alpha);
    }
    draw_primitive_end();
}

// the hand, pushing out of the pillar's right side fist-first
if (show_hand)
{
    var _w  = sprite_get_width(spr_tower_titanhand);
    var _h  = sprite_get_height(spr_tower_titanhand);
    var _sx = (1 - hand_reveal) * hand_reveal_px;
    draw_sprite_part_ext(spr_tower_titanhand, floor(hand_frame), _sx, 0, _w - _sx, _h,
                         hand_root_x, hand_y - sprite_get_yoffset(spr_tower_titanhand) * hand_scale,
                         hand_scale, hand_scale, c_white, 1);
}

// the laser, out of the eye in its palm: the tip sits on the eye and the beam runs along laser_dir
if (show_laser)
{
    var _spr = laser_looping ? spr_titanbeam_loop : spr_tower_titanbeam_start;
    var _img = laser_looping ? floor(laser_frame) mod sprite_get_number(_spr)
                             : clamp(floor(frame), 0, sprite_get_number(_spr) - 1);
    var _ang = laser_dir + 90; // the sprites point down; this turns "down" into laser_dir
    var _ex  = eye_x();
    var _ey  = eye_y();
    var _d0  = (sprite_get_yoffset(_spr) - beam_tip_px) * laser_scale;
    draw_sprite_ext(_spr, _img, _ex + lengthdir_x(_d0, laser_dir), _ey + lengthdir_y(_d0, laser_dir),
                    laser_scale, laser_scale, _ang, c_white, 1);

    // the rest of the beam, past the tip sprite, until it's off-screen
    if (laser_looping || _img >= beam_solid_frame)
    {
        var _len = (sprite_get_height(_spr) - beam_tip_px) * laser_scale;
        var _mh  = sprite_get_height(spr_titanbeam_midsection) * laser_scale;
        var _mi  = _img mod sprite_get_number(spr_titanbeam_midsection);
        for (var k = 0; k < laser_segments; k++)
        {
            var _dist = _len + _mh * (k + 0.5);
            draw_sprite_ext(spr_titanbeam_midsection, _mi, _ex + lengthdir_x(_dist, laser_dir), _ey + lengthdir_y(_dist, laser_dir),
                            laser_scale, laser_scale, _ang, c_white, 1);
        }
    }
}
draw_set_color(c_white);