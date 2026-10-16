// the Titan rising out of the fountain after the Knight's swords drop under the platform.
// lives on the "Titan" layer (345): in front of the dark fountain (350), behind the floor tiles (300)

// keep the shadow tint off this layer so the glow stays bright
if (instance_exists(obj_shadow_tint)) array_push(obj_shadow_tint.skip_layers, layer_get_name(layer));

// --- tuning: placement ---
scale         = 2;
fx            = instance_exists(obj_dark_fountain) ? obj_dark_fountain.x : room_width / 2;
base_bottom_y = 384;    // room y of the pool's bottom edge (platform edge is 364, so the pool's front sits under the tiles)
tower_top_y   = -300;   // where the stone pillar ends (above the screen, you see it on the pan up)
beam_rise     = 360;    // how far the light beam sticks up out of the pillar top
pan_margin    = 70;     // space above the beam's tip once the camera's up there
hand_x        = fx - sprite_get_width(spr_titantower_piece) * scale / 2 - 40; // the arm's root, just past the pillar's left edge
hand_y        = 200;    // middle of the hand sprite

// --- tuning: timing (frames) ---
start_delay   = 30;
rumble_time   = 70;     // ground shakes before the burst
loop_time     = 180;    // geyser running before it hardens
harden_time   = 100;    // stone climbing from the pool to the top of the pillar
settle_time   = 50;
pan_up_time   = 210;
beam_hold     = 150;    // beam looping before the camera comes back down
pan_down_time = 160;
hand_wait     = 40;
hand_emerge   = 14;     // frames for the arm to push out of the pillar

// --- tuning: feel ---
rumble_max    = 3;      // shake while it builds
burst_shake   = 8;      // the column slamming up / the flashes
loop_shake    = 1.5;    // under the running geyser
flash_fade    = 45;     // frames for a white screen flash to fade

// --- tuning: sounds (noone to skip) ---
rumble_sound  = noone;
burst_sound   = snd_explosion;
column_sound  = snd_impact;
harden_sound  = snd_closet_impact;
ring_sound    = snd_spear_appear;
beam_sound    = snd_explosion;
hand_sound    = snd_impact;

// --- sprite facts (their own pixels) ---
pool_bottom_px   = 858; // bottom of the pool ellipse in the 900-tall fountain sprites
column_frame     = 10;  // burst frame where the full column slams up
beam_tip_px      = 32;  // tip of the beam in the beam sprites
beam_flash_frame = 5;   // beam-start frame with the big flash
beam_solid_frame = 6;   // beam-start frame where the beam's a solid column
hand_reveal_px   = 245; // right edge of the fist in the first hand frames

// --- state ---
state = "wait";
t = 0;
frame = 0;              // burst / beam-start animation
loop_frame = 0;         // geyser loop animation
beam_frame = 0;
hand_frame = 0;
hand_reveal = 0;
flash = 0;
pool_white = 0;
stone_y = base_bottom_y;  // top of the stone; at the pool = no stone yet
hardening = false;
show_burst = false;
show_geyser = false;
show_beam = false;
beam_looping = false;
show_hand = false;
cam_from = 0;
cam_to = 0;

play_snd = function(_s) { if (_s != noone) audio_play_sound(_s, 1, false); }

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
draw_column = function(_spr, _img, _anchor, _top, _bottom)
{
    if (_bottom <= _top) return;
    var _w    = sprite_get_width(_spr);
    var _th   = sprite_get_height(_spr) * scale;
    var _left = fx - sprite_get_xoffset(_spr) * scale;
    var _k    = max(0, floor((_anchor - _bottom) / _th)); // skip tiles fully under _bottom

    for (var _tb = _anchor - _k * _th; _tb > _top; _tb -= _th)
    {
        var _tt = _tb - _th;
        var _vt = max(_tt, _top);
        var _vb = min(_tb, _bottom);
        if (_vb <= _vt) continue;
        draw_sprite_part_ext(_spr, _img, 0, (_vt - _tt) / scale, _w, (_vb - _vt) / scale,
                             _left, _vt, scale, scale, c_white, 1);
    }
}