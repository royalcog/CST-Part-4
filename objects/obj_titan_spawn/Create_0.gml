// the Titan rising out of the fountain after the Knight's swords go under the platform.
// lives on the "Titan" layer (345): in front of the dark fountain (350), behind the floor tiles (300).
// every beat reads its time off a sound, so the animation always lines up with the audio:
// snd_titanfountain (started by obj_rm_two_scene on the throw) runs the geyser, petrify and hand,
// snd_titan_petrify_blast runs the laser.

if (instance_exists(obj_shadow_tint)) array_push(obj_shadow_tint.skip_layers, layer_get_name(layer));

// --- tuning: placement ---
scale         = 2;      // the pool / burst / geyser
fx            = instance_exists(obj_dark_fountain) ? obj_dark_fountain.x : room_width / 2;
dark_scale    = instance_exists(obj_dark_fountain) ? obj_dark_fountain.scale : 2;
pillar_half   = sprite_get_width(spr_fountain) * dark_scale / 2;        // the pillar = the dark fountain's width
tower_scale   = pillar_half * 2 / sprite_get_width(spr_titantower_piece);
base_bottom_y = 384;    // room y of the pool's bottom edge (the platform edge is 364)
hand_scale    = 0.9;    // so the hand fits between the pillar and the right edge of the screen
hand_overlap  = 6;      // px the arm's root starts inside the pillar
hand_top_gap  = 150;    // the hand's middle sits this far below the top of the screen
laser_dir     = 270;    // which way the laser fires (GM direction: 270 = down at the party, 0 = right)
laser_scale   = 1;
laser_segments = 4;     // extra beam pieces past the tip, so it always reaches off-screen

// --- timeline: seconds into snd_titanfountain ---
burst_at       = 2.5;   // splash starts; its last frame (the full column) lands on the sound's hit at 4.25
knight_move_at = 4.25;  // the Knight gets out of the way as the column hits
pan_at         = 6.0;   // camera rises up the geyser
pan_time       = 1.6;
pan_dist       = 300;   // px
petrify_at     = 11.0;  // hard cut: the geyser turns to dark stone
shatter_at     = 14.9;  // the dark shell starts breaking off from the bottom...
shatter_end    = 17.0;  // ...and the crack reaches the top of the screen as the fountain sound ends
hand_at        = 17.2;  // the hand bursts out of the pillar
hand_emerge    = 0.25;  // seconds for the arm to push out
laser_gap      = 0.3;   // seconds after the hand's anim ends before the laser starts charging

// --- laser timeline: seconds into snd_titan_petrify_blast ---
laser_flash_time = 1.5; // the sound's hit: the charge ring bursts into the beam
hum_at           = 3.0; // the loop fades in under the blast's tail
hum_fade         = 750; // ms

// --- sounds (noone to skip) ---
fountain_sound = snd_titanfountain;
petrify_sound  = snd_petrify;
hand_sound     = noone;                   // nothing uploaded for the hand
laser_sound    = snd_titan_petrify_blast;
hum_sound      = snd_titan_blastloop;

// --- the Knight getting out of the way ---
knight_aside_x   = 760;  // where his head ends up: off to the right of the geyser
knight_aside_dy  = -20;
knight_move_time = 50;   // frames

// --- the dark shell + shatter ---
dark_col          = make_color_rgb(70, 70, 78);
dark_col2         = make_color_rgb(40, 40, 46);
dark_layer2_alpha = 0.6;
dark_scroll_spd   = 0.6;
dark_scroll_spd2  = 1.0;
cyan_line_w       = 8;    // the thin bit of geyser left in the middle when it petrifies
cyan_line_time    = 30;   // frames
debris_rate       = 5;    // chunks per frame at the crack
debris_grav       = 0.25;
debris_dark       = make_color_rgb(55, 55, 62);
debris_light      = make_color_rgb(150, 150, 150);

// --- white flashes (0 = none) ---
column_flash = 0.5;
hand_flash   = 0.4;
laser_flash  = 0.8;
flash_fade   = 45;      // frames

// --- sprite facts (their own pixels) ---
pool_bottom_px   = 858;              // bottom of the pool ellipse in the 900-tall fountain sprites
beam_tip_px      = 32;               // tip of the beam in the beam sprites
beam_flash_frame = 5;                // beam-start frame with the big flash
beam_solid_frame = 6;                // beam-start frame where the beam's a solid column
hand_reveal_px   = 245;              // right edge of the fist in the first hand frames
hand_eye         = { x: 212, y: 95 }; // the eye in the palm, last hand frame

// --- state ---
state = "pool";
t_all = 0;
loop_frame = 0;
frame = 0;
flash = 0;
pool_white = 1;
show_pool = true;
show_burst = false;
show_geyser = false;
petrified = false;
shattering = false;
cyan_line = 0;
front_y = base_bottom_y;
front_from = 0;
front_to = 0;
dark_scroll = 0;
dark_scroll2 = 0;
debris = [];
pan_from = 0;
pan_done = false;
show_hand = false;
hand_frame = 0;
hand_reveal = 0;
hand_root_x = fx + pillar_half - hand_overlap;
hand_y = 0;
laser_at = 0;
show_laser = false;
laser_looping = false;
laser_frame = 0;
laser_t = 0;

snd_fountain = -1;
snd_laser    = -1;
snd_hum      = -1;

scene          = instance_exists(obj_rm_two_scene) ? instance_find(obj_rm_two_scene, 0) : noone;
knight_moved   = false;
knight_moving  = false;
knight_t       = 0;
knight_from_x  = 0;
knight_from_y0 = 0;

play_snd = function(_s, _loop = false)
{
    return (_s != noone) ? audio_play_sound(_s, 1, _loop) : -1;
}

/// seconds into a playing sound; if it isn't playing, _fallback_t frames turned into seconds
snd_pos = function(_inst, _fallback_t)
{
    if (_inst >= 0 && audio_is_playing(_inst)) return audio_sound_get_track_position(_inst);
    return _fallback_t / game_get_speed(gamespeed_fps);
}

start_knight_move = function()
{
    knight_moved = true;
    if (!instance_exists(scene) || !instance_exists(scene.knight)) return;
    knight_moving  = true;
    knight_t       = 0;
    knight_from_x  = scene.knight.x;
    knight_from_y0 = scene.knight_y0; // obj_rm_two_scene bobs him around this
}

get_cam_y = function()
{
    return instance_exists(obj_camera_controller) ? obj_camera_controller.cam_y : camera_get_view_y(view_camera[0]);
}
set_cam_y = function(_y)
{
    if (instance_exists(obj_camera_controller)) obj_camera_controller.cam_y = _y;
    else camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]), _y);
}

/// one of the 900-tall fountain sprites, lined up so its pool sits on base_bottom_y
draw_pool = function(_spr, _img, _alpha)
{
    var _y = base_bottom_y - (pool_bottom_px - sprite_get_yoffset(_spr)) * scale;
    draw_sprite_ext(_spr, _img, fx, _y, scale, scale, 0, c_white, _alpha);
}

/// tiles _spr upward from _anchor (its bottom edge), only drawing what's between _top and _bottom
draw_column = function(_spr, _img, _anchor, _top, _bottom, _sc = scale, _col = c_white, _alpha = 1)
{
    if (_bottom <= _top) return;
    var _w    = sprite_get_width(_spr);
    var _th   = sprite_get_height(_spr) * _sc;
    var _left = fx - sprite_get_xoffset(_spr) * _sc;
    var _k    = max(0, floor((_anchor - _bottom) / _th)); // skip tiles fully under _bottom

    for (var _tb = _anchor - _k * _th; _tb > _top; _tb -= _th)
    {
        var _tt = _tb - _th;
        var _vt = max(_tt, _top);
        var _vb = min(_tb, _bottom);
        if (_vb <= _vt) continue;
        draw_sprite_part_ext(_spr, _img, 0, (_vt - _tt) / _sc, _w, (_vb - _vt) / _sc,
                             _left, _vt, _sc, _sc, _col, _alpha);
    }
}

/// where the eye in the hand's palm is, in the room
eye_x = function() { return hand_root_x + hand_eye.x * hand_scale; }
eye_y = function() { return hand_y + (hand_eye.y - sprite_get_yoffset(spr_tower_titanhand)) * hand_scale; }

cam_home_y = get_cam_y();

// pick up the fountain sound the sword throw already started, and run the whole scene off it
if (instance_exists(scene) && variable_instance_exists(scene, "snd_drop") && scene.snd_drop >= 0 && audio_is_playing(scene.snd_drop))
    snd_fountain = scene.snd_drop;
else
    snd_fountain = play_snd(fountain_sound);

// the fallback clock (if the sound's off or finished) carries on from wherever the sound is
t_all = round(snd_pos(snd_fountain, 0) * game_get_speed(gamespeed_fps));
pool_flash_start = snd_pos(snd_fountain, t_all);
pool_flash_fade  = 2.0;   // seconds for the white pool to fade to black