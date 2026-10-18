// the Titan in the distance: the stone tower over the fountain's column, its hand out of the side, looking around
var _ts = mini_w / sprite_get_width(spr_titantower_piece);
var _th = sprite_get_height(spr_titantower_piece) * _ts;
for (var _y = mini_base_y; _y > town_top - _th; _y -= _th)
{
    draw_sprite_ext(spr_titantower_piece,    0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
    draw_sprite_ext(spr_titantower_gradient, 0, mini_x, _y - _th / 2, _ts, _ts, 0, c_white, 1);
}

// the hand: its last frames (eye open), swaying from its arm root like it's scanning around
var _hx  = mini_x + mini_w / 2 - 3;
var _hy  = mini_hand_y + sin(anim_t * mini_look_spd * 1.7) * mini_bob;
var _ang = sin(anim_t * mini_look_spd) * mini_look_ang;
draw_sprite_ext(spr_tower_titanhand, 294 + (floor(anim_t / 2) mod 2), _hx, _hy, mini_scale, mini_scale, _ang, c_white, 1);