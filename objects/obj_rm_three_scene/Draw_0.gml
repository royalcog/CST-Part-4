// the Titan in the distance: the stone tower over the fountain's column, its hand out of the side, looking around
var _ts = mini_w / sprite_get_width(spr_titantower_piece);
var _th = sprite_get_height(spr_titantower_piece) * _ts;
for (var _y = mini_base_y; _y > town_top - _th; _y -= _th)
{
    draw_sprite_ext(spr_titantower_piece,    0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
    draw_sprite_ext(spr_titantower_gradient, 0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
}

// the hand, holding still
var _hx = mini_x + mini_w / 2 - 3;
var _hy = mini_hand_y;
draw_sprite_ext(spr_tower_titanhand, mini_hand_frame, _hx, _hy, mini_scale, mini_scale, 0, c_white, 1);

// the tiny laser: from the palm (same spot as the close-up, scaled down) to around the other fountain, cut off there.
// drawn by corner, so the beam sprites' origins don't matter
var _sx  = _hx + 432 * mini_scale / 2;
var _sy  = _hy - 80 * mini_scale / 2;
var _len = point_distance(_sx, _sy, mini_laser_end_x, mini_laser_end_y);
var _dir = point_direction(_sx, _sy, mini_laser_end_x, mini_laser_end_y);
var _ang = _dir - 270;                                   // the sprites point down
var _dx  = lengthdir_x(1, _dir), _dy = lengthdir_y(1, _dir);   // along the beam
var _nx  = lengthdir_x(1, _ang), _ny = lengthdir_y(1, _ang);   // across it
var _s   = mini_beam_scale;
var _bi  = floor(anim_t / 2) mod sprite_get_number(spr_titanbeam_loop);
var _d   = 0;

// the tip piece first (cut short if the whole laser's shorter than it)
var _lw = sprite_get_width(spr_titanbeam_loop), _lh = sprite_get_height(spr_titanbeam_loop);
var _ph = min(_lh, _len / _s);
draw_sprite_general(spr_titanbeam_loop, _bi, 0, 0, _lw, _ph,
                    _sx - _nx * (_lw / 2) * _s, _sy - _ny * (_lw / 2) * _s,
                    _s, _s, _ang, c_white, c_white, c_white, c_white, 1);
_d += _ph * _s;

// then the midsection the rest of the way
var _mw = sprite_get_width(spr_titanbeam_midsection), _mh = sprite_get_height(spr_titanbeam_midsection);
var _mi = _bi mod sprite_get_number(spr_titanbeam_midsection);
while (_d < _len)
{
    var _p = min(_mh, (_len - _d) / _s);
    draw_sprite_general(spr_titanbeam_midsection, _mi, 0, 0, _mw, _p,
                        _sx + _dx * _d - _nx * (_mw / 2) * _s, _sy + _dy * _d - _ny * (_mw / 2) * _s,
                        _s, _s, _ang, c_white, c_white, c_white, c_white, 1);
    _d += _p * _s;
}