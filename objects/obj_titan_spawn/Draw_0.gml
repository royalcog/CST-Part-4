var _vt = camera_get_view_y(view_camera[0]) - 20;
var _vb = _vt + camera_get_view_height(view_camera[0]) + 40;

// the light beam, behind the pillar (its lower end disappears into the stone)
if (show_beam)
{
    var _spr  = beam_looping ? spr_titanbeam_loop : spr_tower_titanbeam_start;
    var _img  = beam_looping ? floor(beam_frame) mod sprite_get_number(_spr)
                             : min(floor(frame), sprite_get_number(_spr) - 1);
    var _apex = tower_top_y - beam_rise;
    draw_sprite_ext(_spr, _img, fx, _apex + (sprite_get_yoffset(_spr) - beam_tip_px) * scale, scale, scale, 0, c_white, 1);

    // only needed if beam_rise is taller than the tip sprite
    var _tip_bottom = _apex + (sprite_get_height(_spr) - beam_tip_px) * scale;
    if ((beam_looping || _img >= beam_solid_frame) && _tip_bottom < tower_top_y)
        draw_column(spr_titanbeam_midsection, _img mod sprite_get_number(spr_titanbeam_midsection),
                    tower_top_y, _tip_bottom, tower_top_y);
}

// the burst
if (show_burst)
{
    var _i = min(floor(frame), sprite_get_number(spr_titan_fountain_burst) - 1);
    draw_pool(spr_titan_fountain_burst_base, _i, 1);
    draw_pool(spr_titan_fountain_burst, _i, 1);
}

// the pool: glowing while the geyser runs, flashing white as it hardens
if (show_geyser && !hardening)
    draw_pool(spr_titan_fountain_loop_base, floor(loop_frame) mod sprite_get_number(spr_titan_fountain_loop_base), 1);
if (pool_white > 0)
    draw_pool(spr_titan_fountain_loop_base_white, 0, pool_white);

// the geyser column, above wherever the stone's reached
if (show_geyser)
{
    draw_column(spr_titan_fountain_loop, floor(loop_frame) mod sprite_get_number(spr_titan_fountain_loop),
                base_bottom_y, _vt, min(_vb, stone_y));
    if (!hardening)
        draw_pool(spr_titan_fountain_loop_rings, floor(loop_frame) mod sprite_get_number(spr_titan_fountain_loop_rings), 1);
}

// the stone pillar + its edge shading
if (stone_y < base_bottom_y)
{
    var _top = max(stone_y, _vt), _bot = min(base_bottom_y, _vb);
    draw_column(spr_titantower_piece,    0, base_bottom_y, _top, _bot);
    draw_column(spr_titantower_gradient, 0, base_bottom_y, _top, _bot);

    // a bright line where the stone's still climbing
    if (hardening && stone_y > tower_top_y)
    {
        var _hw = sprite_get_width(spr_titantower_piece) * scale / 2;
        gpu_set_blendmode(bm_add);
        draw_set_color(c_white);
        draw_set_alpha(0.8);
        draw_rectangle(fx - _hw, stone_y - 3, fx + _hw, stone_y + 3, false);
        draw_set_alpha(1);
        gpu_set_blendmode(bm_normal);
    }
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