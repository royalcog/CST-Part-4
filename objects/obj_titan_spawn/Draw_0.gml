var _vt = camera_get_view_y(view_camera[0]) - 20;
var _vb = _vt + camera_get_view_height(view_camera[0]) + 40;

// the light beam, behind the pillar (its lower end disappears into the stone)
if (show_beam)
{
    var _spr  = beam_looping ? spr_titanbeam_loop : spr_tower_titanbeam_start;
    var _img  = beam_looping ? floor(beam_frame) mod sprite_get_number(_spr)
                             : min(floor(frame), sprite_get_number(_spr) - 1);
    var _apex = tower_top_y - beam_rise;
    draw_sprite_ext(_spr, _img, fx, _apex + (sprite_get_yoffset(_spr) - beam_tip_px) * tower_scale, tower_scale, tower_scale, 0, c_white, 1);

    var _tip_bottom = _apex + (sprite_get_height(_spr) - beam_tip_px) * tower_scale;
    if ((beam_looping || _img >= beam_solid_frame) && _tip_bottom < tower_top_y)
        draw_column(spr_titanbeam_midsection, _img mod sprite_get_number(spr_titanbeam_midsection),
                    tower_top_y, _tip_bottom, tower_top_y, tower_scale);
}

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

// the geyser
if (show_geyser)
{
    var _li = floor(loop_frame);
    draw_pool(spr_titan_fountain_loop_base, _li mod sprite_get_number(spr_titan_fountain_loop_base), 1);
    draw_column(spr_titan_fountain_loop, _li mod sprite_get_number(spr_titan_fountain_loop), base_bottom_y, _vt, _vb);
    draw_pool(spr_titan_fountain_loop_rings, _li mod sprite_get_number(spr_titan_fountain_loop_rings), 1);
}

if (petrified)
{
    var _hw = sprite_get_width(spr_fountain) * dark_scale / 2;

    // the dark stone shell, above the crack
    var _top = max(tower_top_y, _vt);
    var _bot = min(front_y, _vb);
    if (_bot > _top)
    {
        draw_set_color(c_black);
        draw_rectangle(fx - _hw, _top, fx + _hw, _bot, false);

        var _th = sprite_get_height(spr_fountain) * dark_scale;
        draw_column(spr_fountain, 0, base_bottom_y + _th - (dark_scroll mod _th), _top, _bot, dark_scale, dark_col, 1);
        gpu_set_blendmode(bm_add);
        draw_column(spr_fountain, 0, base_bottom_y + _th - ((dark_scroll2 + _th / 3) mod _th), _top, _bot, dark_scale, dark_col2, dark_layer2_alpha);
        gpu_set_blendmode(bm_normal);
    }

    // the grey tower, below the crack
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

// the hand, pushing out of the pillar fist-first
if (show_hand)
{
    var _w  = sprite_get_width(spr_tower_titanhand);
    var _h  = sprite_get_height(spr_tower_titanhand);
    var _sx = (1 - hand_reveal) * hand_reveal_px;
    draw_sprite_part_ext(spr_tower_titanhand, floor(hand_frame), _sx, 0, _w - _sx, _h,
                         hand_x, hand_y - sprite_get_yoffset(spr_tower_titanhand) * scale,
                         scale, scale, c_white, 1);
}
draw_set_color(c_white);