// the Titan rising out of the fountain, after the Knight's swords go under the platform.
// lives on the "Titan" layer (345): in front of the dark fountain (350), behind the floor tiles (300).
// timing:
//  - pool -> burst -> geyser runs off snd_titanfountain (started by obj_rm_two_scene on the throw)
//  - from the geyser fizzling on, it follows Deltarune's own cutscene (30fps frames, "g" below)

if (instance_exists(obj_shadow_tint)) array_push(obj_shadow_tint.skip_layers, layer_get_name(layer));

// --- placement ---
scale         = 2;      // everything Deltarune draws at 2x
fx            = instance_exists(obj_dark_fountain) ? obj_dark_fountain.x : room_width / 2;
pillar_w      = 274;    // Deltarune's pillar: 280 * 0.98
dark_scale    = pillar_w / sprite_get_width(spr_fountain);
tower_scale   = pillar_w / sprite_get_width(spr_titantower_piece);
base_bottom_y = 384;    // room y of the pool's bottom edge (the platform edge is 364)

// --- the fountain part: seconds into snd_titanfountain ---
burst_at       = 2.5;   // splash starts; its last frame (the full column) lands on the sound's hit at 4.25
knight_move_at = 4.25;  // the Knight gets out of the way as the column hits
pan_at         = 6.0;   // camera rises up the geyser
pan_time       = 2.0;
pan_dist       = 560;   // px
fizzle_at      = 11.0;  // the geyser fizzles out

// --- after that, Deltarune's timings (game frames at 30fps) ---
fizzle_c1      = 6.0;   // the fizzle is 180 frames into the game's "con 1" (the dark column starts drawing at 60)
fizzle_speed   = 0.4;   // spr_tower_fizzleout's image_speed
fizzle_len_g   = 28;    // the fizzle's hidden 28 frames in
fizzle_pitch   = 0.19;  // the fountain sound slides down to this pitch...
fizzle_pitch_g = 52;    // ...over this many frames
petrify_g      = 313;   // it petrifies at con 1 frame 313
petrify_len_g  = 60;    // the petrifying takes 60 frames
seg_gap_g      = 6;     // one section every 6 frames...
seg_count      = 9;     // ...9 of them...
seg_h          = 80;    // ...80px apart, from the bottom of the screen up
seg_dx         = 6;     // the game puts them 6px right of centre
seg_speed      = 0.5;   // spr_tower_petrification's image_speed (it holds its last frame)
ghost_grow     = 0.1;   // the ghost two sections down stretches this much wider...
ghost_len_g    = 30;    // ...over 30 frames, fading out
ghost_alpha    = 0.6;
crack_speed    = 0.25;  // the cracks' image_speed
cracks_def     = [
    { g: 80,  dx: -50, dy: -120, spr: spr_petrifycrack_1, debris: spr_petrifycrack_1_debris, gain: 0.2,  pitch: 1    },
    { g: 95,  dx:  60, dy:  220, spr: spr_petrifycrack_2, debris: spr_petrifycrack_2_debris, gain: 0.25, pitch: 0.9  },
    { g: 110, dx: -80, dy:  50,  spr: spr_petrifycrack_3, debris: spr_petrifycrack_3_debris, gain: 0.18, pitch: 1.03 }
];
thunder_g        = 198;
handburst_g      = 200;   // the pillar bursts open
handburst_speed  = 0.25;
handburst_dy     = 26;    // below the screen's centre
hb_debris_move_g = 32;    // the burst's debris starts sliding right after 32 frames...
hb_debris_hspeed = 14;    // ...at 14px per game frame
wallblast_g      = 224;
foreground_g     = 226;   // the pillar's broken front edge goes in front of the hand
hand_g           = 228;   // the hand flies out
pan_right_g      = 230;   // the camera snaps right...
pan_right_len_g  = 4;     // ...in 4 frames, by one Deltarune screen (640), plus the extra width this screen has
pan_right        = 640 + (camera_get_view_width(view_camera[0]) - 640) / 2;
big_debris_g     = 230;   // twelve rocks fly off
hand_start_dx    = -280;  // the hand starts this far left of the screen's centre...
hand_dy          = 26;    // ...and this far below it
hand_slide       = 600;   // px it travels: 150px/frame easing to 0 over 12 frames
hand_slide_g     = 12;
blast_idx        = 220;   // hand frame where snd_titan_petrify_blast plays
beam_idx         = 257;   // hand frame where the beam fires
beam_from        = { x: 288, y: 112 };  // the beam slides from here...
beam_to          = { x: 432, y: -80 };  // ...to here (relative to the hand) over 10 frames
beam_slide_g     = 10;
beam_angle       = -35;
beam_start_g     = 20;    // frames of spr_tower_titanbeam_start before it switches to the loop
hand_loop_from   = 294;   // the hand loops its last 3 frames
hum_at           = 3.0;   // seconds into the blast sound when the beam's loop fades in
hum_fade         = 750;   // ms

// --- sounds (noone to skip) ---
fountain_sound  = snd_titanfountain;
petrify_sound   = snd_petrify;
gravel_sound    = snd_petrify_gravel;
thunder_sound   = snd_petrify_gravel_thunder;
wallblast_sound = snd_petrify_wallblast;
laser_sound     = snd_titan_petrify_blast;
hum_sound       = snd_titan_blastloop;

// --- the Knight getting out of the way ---
knight_aside_x   = 760;
knight_aside_dy  = -20;
knight_move_time = 50;   // frames

// --- looks ---
dark_scroll_spd = 0.6;   // the dark column's texture, once it's dark
pool_flash_fade = 2.0;   // seconds for the white pool to fade to black

// --- sprite facts ---
pool_bottom_px = 858;    // bottom of the pool ellipse in the 900-tall fountain sprites

// --- state ---
state = "pool";
t_all = 0;
fizzled = false;
fz_t = 0;
fired = {};
cur_g1 = -1000;
cur_g2 = -1000;
cur_g3 = -1000;
loop_frame = 0;
frame = 0;
pool_white = 1;
show_pool = true;
show_burst = false;
show_geyser = false;
fizzle_frame = 0;
show_fizzle = false;
dark_visible = false;
dark_col = c_white;
dark_col2 = c_white;
dark_scroll = 0;
dark_scroll2 = 0;
petrify_started = false;
cam_bottom = 0;
cam_cy = 0;
segs = [];
ghosts = [];
cracks = [];
handburst = noone;
foreground = noone;
debris = [];
pan_done = false;
pan_x_from = 0;
show_hand = false;
hand_x0 = 0;
hand_x = 0;
hand_y = 0;
hand_frame = 0;
show_beam = false;
beam_spr = spr_tower_titanbeam_start;
beam_img = 0;
beam_x = 0;
beam_y = 0;
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

play_snd = function(_s, _loop = false, _gain = 1, _pitch = 1)
{
    return (_s != noone) ? audio_play_sound(_s, 1, _loop, _gain, 0, _pitch) : -1;
}

/// seconds into a playing sound; if it isn't playing, _fallback_t frames turned into seconds
snd_pos = function(_inst, _fallback_t)
{
    if (_inst >= 0 && audio_is_playing(_inst)) return audio_sound_get_track_position(_inst);
    return _fallback_t / game_get_speed(gamespeed_fps);
}

/// true the first time it's asked about _key, false after
once = function(_key)
{
    if (variable_struct_exists(fired, _key)) return false;
    fired[$ _key] = true;
    return true;
}

/// frame of a play-once animation started at game frame _born_g, holding its last frame
anim_frame = function(_spr, _now_g, _born_g, _speed)
{
    return clamp(floor((_now_g - _born_g) * _speed), 0, sprite_get_number(_spr) - 1);
}

start_knight_move = function()
{
    knight_moved = true;
    if (!instance_exists(scene) || !instance_exists(scene.knight)) return;
    knight_moving  = true;
    knight_t       = 0;
    knight_from_x  = scene.knight.x;
    knight_from_y0 = scene.knight_y0;
}

get_cam_x = function() { return instance_exists(obj_camera_controller) ? obj_camera_controller.cam_x : camera_get_view_x(view_camera[0]); }
get_cam_y = function() { return instance_exists(obj_camera_controller) ? obj_camera_controller.cam_y : camera_get_view_y(view_camera[0]); }
set_cam_x = function(_x)
{
    if (instance_exists(obj_camera_controller)) obj_camera_controller.cam_x = _x;
    else camera_set_view_pos(view_camera[0], _x, camera_get_view_y(view_camera[0]));
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
    var _k    = max(0, floor((_anchor - _bottom) / _th));

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

cam_home_y = get_cam_y();

// pick up the fountain sound the sword throw already started, and run the fountain part off it
if (instance_exists(scene) && variable_instance_exists(scene, "snd_drop") && scene.snd_drop >= 0 && audio_is_playing(scene.snd_drop))
    snd_fountain = scene.snd_drop;
else
    snd_fountain = play_snd(fountain_sound);

t_all = round(snd_pos(snd_fountain, 0) * game_get_speed(gamespeed_fps));
pool_flash_start = snd_pos(snd_fountain, t_all);