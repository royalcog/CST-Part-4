// the Titan in the distance: the stone tower over the fountain's column, its hand out of the side, firing
var _ts = mini_w / sprite_get_width(spr_titantower_piece);
var _th = sprite_get_height(spr_titantower_piece) * _ts;
for (var _y = mini_base_y; _y > town_top - _th; _y -= _th)
{
    draw_sprite_ext(spr_titantower_piece,    0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
    draw_sprite_ext(spr_titantower_gradient, 0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
}

// the hand, on its last frames like the game
var _hx = mini_x + mini_w / 2 - 3;
var _hy = mini_hand_y;
draw_sprite_ext(spr_tower_titanhand, 294 + (floor(anim_t / 2) mod 2), _hx, _hy, mini_scale, mini_scale, 0, c_white, 1);

// its laser: the tip piece, then the midsection to make it long. drawn by corner, so the origins don't matter
var _s   = mini_scale;
var _bx  = _hx + 432 * _s / 2, _by = _hy - 80 * _s / 2;   // same spot as the close-up, scaled down
var _ang = mini_beam_ang;
var _dx  = lengthdir_x(1, 270 + _ang), _dy = lengthdir_y(1, 270 + _ang);   // down the beam
var _nx  = lengthdir_x(1, _ang),       _ny = lengthdir_y(1, _ang);         // across it
var _bi  = floor(anim_t / 2) mod sprite_get_number(spr_titanbeam_loop);

var _lw = sprite_get_width(spr_titanbeam_loop), _lh = sprite_get_height(spr_titanbeam_loop);
draw_sprite_general(spr_titanbeam_loop, _bi, 0, 0, _lw, _lh, _bx - _nx * (_lw / 2) * _s, _by - _ny * (_lw / 2) * _s,
                    _s, _s, _ang, c_white, c_white, c_white, c_white, 1);

var _mw = sprite_get_width(spr_titanbeam_midsection), _mh = sprite_get_height(spr_titanbeam_midsection);
var _mi = _bi mod sprite_get_number(spr_titanbeam_midsection);
for (var _d = _lh * _s; _d < mini_beam_len; _d += _mh * _s)
{
    draw_sprite_general(spr_titanbeam_midsection, _mi, 0, 0, _mw, _mh,
                        _bx + _dx * _d - _nx * (_mw / 2) * _s, _by + _dy * _d - _ny * (_mw / 2) * _s,
                        _s, _s, _ang, c_white, c_white, c_white, c_white, 1);
}