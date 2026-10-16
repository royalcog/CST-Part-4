// the Titan rising out of the fountain after the Knight's swords drop under the platform.
// lives on the "Titan" layer (345): in front of the dark fountain (350), behind the floor tiles (300)

// keep the shadow tint off this layer so the glow stays bright
if (instance_exists(obj_shadow_tint)) array_push(obj_shadow_tint.skip_layers, layer_get_name(layer));

// --- tuning: placement ---
scale         = 2;      // the geyser / burst / hand
fx            = instance_exists(obj_dark_fountain) ? obj_dark_fountain.x : room_width / 2;
dark_scale    = instance_exists(obj_dark_fountain) ? obj_dark_fountain.scale : 2; // the petrified column = the dark fountain's size
tower_scale   = sprite_get_width(spr_fountain) * dark_scale / sprite_get_width(spr_titantower_piece); // grey tower as wide as the dark column
base_bottom_y = 384;    // room y of the pool's bottom edge (platform edge is 364, so the pool's front sits under the tiles)
tower_top_y   = -300;   // where the pillar ends
beam_rise     = 360;    // how far the light beam sticks up out of the pillar top
pan_margin    = 70;     // space above the beam's tip once the camera's up there
hand_x        = fx - sprite_get_width(spr_fountain) * dark_scale / 2 - 40; // the arm's root, just past the pillar's left edge
hand_y        = 200;    // middle of the hand sprite

// --- tuning: the timeline, in seconds since the swords hit (synced to snd_titanfountain) ---
pool_flash_fade = 2.0;  // pool flashes white, then fades to the black pool
burst_at        = 2.5;  // splash starts (its last frame, the full column, lands on the sound's hit at 4.25)
knight_move_at  = 4.25; // the Knight gets out of the way as the column hits
pan1_at         = 6.0;  // camera starts rising up the geyser
pan1_time       = 1.6;
pan1_dist       = 300;  // px
petrify_at      = 11.0; // hard cut: the geyser turns to dark stone
shatter_at      = 14.9; // the dark shell starts breaking off from the bottom

// --- tuning: the Knight getting out of the way ---
knight_aside_x   = 760;  // where his head ends up: off to the right of the geyser
knight_aside_dy  = -20;  // and a little higher
knight_move_time = 50;   // frames

// --- tuning: sounds (noone to skip) ---
fountain_sound    = snd_titanfountain;       // pool flash -> burst -> geyser (~17s, runs under everything)
petrify_sound     = snd_petrify;             // the cut to dark stone
blast_sound       = snd_titan_petrify_blast; // builds up, then hits as the shell starts cracking
blast_hit         = 1.5;                     // seconds into blast_sound where it hits
hum_sound         = snd_titan_blastloop;     // loops once the blast dies down
hum_at            = 3.0;                     // seconds into blast_sound when the hum fades in
hum_fade          = 750;                     // ms
hum_far_gain      = 0.3;                     // hum volume once the camera's back down
ring_sound        = snd_spear_appear;        // placeholder: the beam isn't in the video
beam_flash_sound  = snd_explosion;           // placeholder
hand_sound        = snd_impact;              // placeholder

// --- tuning: the dark column + shatter ---
dark_col          = make_color_rgb(70, 70, 78);
dark_col2         = make_color_rgb(40, 40, 46);
dark_layer2_alpha = 0.6;
dark_scroll_spd   = 0.6;  // same as the dark fountain
dark_scroll_spd2  = 1.0;
cyan_line_w       = 8;    // the thin cyan line left in the middle when it petrifies
cyan_line_time    = 30;   // frames for it to shrink away
shatter_speed     = 6;    // px per frame the crack climbs
debris_rate       = 5;    // chunks spawned per frame at the crack
debris_grav       = 0.25;
debris_dark       = make_color_rgb(55, 55, 62);
debris_light      = make_color_rgb(150, 150, 150);

// --- tuning: timing (frames) for the beam + hand ---
start_delay   = 0;
settle_time   = 50;
pan_up_time   = 210;
beam_hold     = 150;
pan_down_time = 160;
hand_wait     = 40;
hand_emerge   = 14;

// --- tuning: feel ---
impact_shake  = 6;      // the swords hitting
burst_shake   = 8;      // the column slamming up / the flashes
loop_shake    = 1.5;    // under the running geyser
shatter_shake = 2;      // while the shell breaks off
flash_fade    = 45;     // frames for a white screen flash to fade

// --- sprite facts (their own pixels) ---
pool_bottom_px   = 858; // bottom of the pool ellipse in the 900-tall fountain sprites
beam_tip_px      = 32;  // tip of the beam in the beam sprites
beam_flash_frame = 5;   // beam-start frame with the big flash
beam_solid_frame = 6;   // beam-start frame where the beam's a solid column
hand_reveal_px   = 245; // right edge of the fist in the first hand frames

// --- state ---
state = "pool";
t = 0;                  // frames in the current state
t_all = 0;              // frames since the swords hit (fallback clock if the fountain sound's off)
frame = 0;
loop_frame = 0;
beam_frame = 0;
hand_frame = 0;
hand_reveal = 0;
flash = 0;
pool_white = 1;
show_pool = true;
show_burst = false;
show_geyser = false;
petrified = false;
cyan_line = 0;
front_y = base_bottom_y;   // the crack: dark stone above it, grey tower below
dark_scroll = 0;
dark_scroll2 = 0;
debris = [];
show_beam = false;
beam_looping = false;
show_hand = false;
pan1_done = false;
cam_from = 0;
cam_to = 0;

snd_fountain = -1;
snd_blast    = -1;
snd_hum      = -1;
blast_t      = 0;

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

/// the Knight darts off to the side, out of the geyser's way
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
cam_home_y = get_cam_y();

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