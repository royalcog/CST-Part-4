// the wide shot after the Titan's hand (changed from the game): the beam comes down on them, Ralsei throws up
// a huge shield that holds it back while it's shoved down, the Knight comes down to their level, turns into his
// flying form and zooms through them (they spin, then reel), Susie yells "Watch out!", and they jump clear as the
// shield breaks and the beam hits where they were standing. made by obj_titan_spawn at the cut.
// everything it draws is in Draw End: in front of everyone, and the shadow tint leaves it alone

scene = instance_exists(obj_rm_two_scene) ? instance_find(obj_rm_two_scene, 0) : noone;
fps_  = game_get_speed(gamespeed_fps);

// --- the beam ---
beam_x     = (instance_exists(obj_dark_fountain) ? obj_dark_fountain.x : room_width / 2) - 6;  // where it crosses the middle of the screen
beam_angle = -12;    // degrees: the top leans right, like the game
beam_scale = 2;
beam_after = 1.2;    // seconds it keeps firing after the shield breaks...
beam_thin  = 0.15;   // ...then thins out over this long
flash_amt  = 0.75;   // white flash when it hits the shield, and when the shield breaks
flash_time = 0.3;    // seconds to fade

beam_cy = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
bdx = lengthdir_x(1, 270 + beam_angle);   // straight down the beam
bdy = lengthdir_y(1, 270 + beam_angle);
beam_ex = 0;   // where it ends (the shield, then past the bottom of the screen)
beam_ey = 0;

/// the beam's x at height _y
line_x = function(_y) { return beam_x + (_y - beam_cy) * bdx / bdy; }

// --- Ralsei's shield: a huge dome of light over both of them (seconds after the cut) ---
react_at     = 0.55;   // he sees it coming...
cast_at      = 0.8;    // ...casts...
shield_at    = 1.05;   // ...the shield's up...
slam_at      = 1.25;   // ...and the beam hits it (when it'd have hit them in the game)
shield_gap   = 50;     // px from the top of the taller one's head to the top of the dome
shield_r     = 260;    // the dome's radius
shield_arc   = 42;     // half its angle (bigger = wider)
shield_th    = 14;     // thickness
shield_grow  = 0.25;   // seconds to grow in
shield_color = make_color_rgb(1, 255, 0);   // Ralsei's colour, same as the finale's barrier
push_speed   = 9;      // px per second the beam shoves it down...
push_max     = 34;     // ...up to this far
push_jitter  = 1.5;    // px it shudders while it's shoved
crack_every  = 0.45;   // seconds between new cracks
spark_rate   = 3;      // sparks per frame where the beam meets it
shard_count  = 36;

// --- the Knight ---
knight_down_at       = 2.8;   // he comes down to their level...
knight_down_time     = 0.8;
knight_level_dy      = -40;   // his middle vs. their feet (negative = up)
knight_transform_gap = 0.4;   // ...a beat, then turns into his flying form, facing them...
knight_fly_gap       = 0.15;  // ...then zooms through them
knight_fly_speed     = 26;    // px per frame
knight_trail_every   = 2;     // frames between afterimages

// --- them spinning, then reeling ---
spin_time     = 0.9;   // seconds
spin_turns    = 2.5;   // full turns (fast, slowing down)
dizzy_time    = 0.8;
dizzy_sway    = 2;     // px
watchout_wait = 0.3;   // after they've both stopped, before Susie yells
watchout_text = "rm2_susie_watchout";

// --- jumping clear (away from the beam) ---
jump_time   = 0.4;     // seconds in the air
jump_h      = 40;      // px
ralsei_jump = 150;     // px
susie_jump  = 160;     // px

// --- sprites ---
susie_dirs  = [spr_susie_walk_down, spr_susie_walk_left, spr_susie_walk_up, spr_susie_walk_right];          // the spin
ralsei_dirs = [spr_ralsei_walk_down, spr_ralsei_walk_left_neutral, spr_ralsei_walk_up, spr_ralsei_walk_right];
susie_air   = spr_susie_shocked;
ralsei_air  = spr_ralsei_shocked;
susie_land  = spr_susie_landed;
ralsei_land = spr_ralsei_fall_wince;   // stand-in: no proper landed sprite for him yet
susie_land_native  = -1;               // which way each landed sprite faces as drawn (-1 left, 1 right)
ralsei_land_native = -1;
ralsei_react_sprite = spr_ralsei_shocked;
ralsei_cast_sprite  = spr_ralsei_spell;

// --- sounds (noone to skip) ---
cast_sound      = snd_spell_pacify;
shield_sound    = snd_sparklegem;
blast_sound     = snd_titan_petrify_blast;
blast_offset    = 1.4;                  // played from its hit
hum_sound       = snd_titan_blastloop;  // looping while it pushes on the shield
hum_gain        = 0.7;
hum_delay       = 0.6;                  // seconds after the hit
crack_sound     = snd_impact;
transform_sound = snd_wing;
zoom_sound      = snd_ultraswing;
break_sound     = snd_glassbreak;

// --- state ---
t       = 0;        // frames since the cut
st      = 0;        // frames in the current state
state   = "wait";   // "wait" (for them to stop reeling) -> "talk" -> "beam_out" -> "done"
fired   = {};
flash   = 0;
beam_on = false;
beam_w  = 1;
beam_t  = 0;
snd_hum = -1;
crack_t = 0;
dazed_t = 0;
shield  = { on: false, grow: 0, cx: 0, cy: 0, push: 0, jx: 0, jy: 0, flash: 0, t: 0, cracks: [] };
shards  = [];
sparks  = [];
kstate  = "";
kt      = 0;
knight_x0 = 0;
knight_from_y = 0;
knight_to_y   = 0;

play = function(_s, _gain = 1, _offset = 0, _pitch = 1, _loop = false)
{
    return (_s != noone) ? audio_play_sound(_s, 1, _loop, _gain, _offset, _pitch) : -1;
}

/// true the first time it's asked about _key, false after
once = function(_key)
{
    if (variable_struct_exists(fired, _key)) return false;
    fired[$ _key] = true;
    return true;
}

set_feet = function(_o, _x, _y)
{
    var _f = scr_get_feet(_o);
    _o.x += _x - _f.x;
    _o.y += _y - _f.y;
}

// --- them ---
heroes = [];
if (instance_exists(obj_ralsei))
    array_push(heroes, { o: obj_ralsei.id, dirs: ralsei_dirs, air: ralsei_air, land: ralsei_land, native: ralsei_land_native,
                         jdist: ralsei_jump, jdir: -1, phase: "stand", t: 0, fx: 0, fy: 0 });
if (instance_exists(obj_susie))
    array_push(heroes, { o: obj_susie.id, dirs: susie_dirs, air: susie_air, land: susie_land, native: susie_land_native,
                         jdist: susie_jump, jdir: 1, phase: "stand", t: 0, fx: 0, fy: 0 });

party_feet_y = 0;
for (var i = 0; i < array_length(heroes); i++) party_feet_y += scr_get_feet(heroes[i].o).y;
party_feet_y = (array_length(heroes) > 0) ? party_feet_y / array_length(heroes) : 394;

// --- the Knight: placed by his sprite's middle, so the sprites' origins don't matter ---
knight_center = function()
{
    var _k = scene.knight, _s = _k.sprite_index;
    return { x: _k.x + (sprite_get_width(_s) / 2 - sprite_get_xoffset(_s)) * _k.image_xscale,
             y: scene.knight_y0 + (sprite_get_height(_s) / 2 - sprite_get_yoffset(_s)) * _k.image_yscale };
}
knight_place = function(_cx, _cy)
{
    var _k = scene.knight, _s = _k.sprite_index;
    _k.x = _cx - (sprite_get_width(_s) / 2 - sprite_get_xoffset(_s)) * _k.image_xscale;
    scene.knight_y0 = _cy - (sprite_get_height(_s) / 2 - sprite_get_yoffset(_s)) * _k.image_yscale;
}

// --- the shield: a slice of a circle facing up the beam, its top right where the beam lands ---
shield_build = function()
{
    var _top = 100000;
    with (obj_susie)  _top = min(_top, bbox_top);
    with (obj_ralsei) _top = min(_top, bbox_top);
    if (_top > 99999) _top = 300;
    var _ay = _top - shield_gap;            // its top, on the beam
    shield.cx = line_x(_ay) + bdx * shield_r;
    shield.cy = _ay + bdy * shield_r;
    shield.on = true;
    shield.grow = 0;
    shield.push = 0;
    shield.cracks = [];
}

/// a point on the shield at angle _a (0 = its top, facing the beam), _off px out from its centre line.
/// the beam shoves the whole thing back along itself
shield_point = function(_a, _off)
{
    var _d = 90 + beam_angle + _a;
    return { x: shield.cx + bdx * shield.push + shield.jx + lengthdir_x(shield_r + _off, _d),
             y: shield.cy + bdy * shield.push + shield.jy + lengthdir_y(shield_r + _off, _d) };
}

shield_shatter = function()
{
    if (!shield.on) return;
    shield.on = false;
    for (var i = 0; i < shard_count; i++)
    {
        var _a  = random_range(-shield_arc, shield_arc);
        var _p  = shield_point(_a, random_range(-shield_th / 2, shield_th / 2));
        var _d  = 270 + beam_angle + _a * 1.5 + random_range(-30, 30);   // blown on and out by the beam
        var _sp = random_range(2, 6);
        array_push(shards, { x: _p.x, y: _p.y, vx: lengthdir_x(_sp, _d), vy: lengthdir_y(_sp, _d),
                             rot: random(360), vr: random_range(-12, 12), len: random_range(5, 12), t: 0 });
    }
}

/// the beam from (_sx,_sy) to (_ex,_ey) along its lean, _ws = how wide (1 = full).
/// the midsection is tiled along it, the last piece cut off exactly at the end
draw_beam = function(_sx, _sy, _ex, _ey, _ws)
{
    var _spr = spr_titanbeam_midsection;
    var _img = floor(beam_t / 2) mod sprite_get_number(_spr);   // 30fps
    var _sw  = sprite_get_width(_spr);
    var _sh  = sprite_get_height(_spr);
    var _xs  = beam_scale * _ws;
    var _len = point_distance(_sx, _sy, _ex, _ey);
    var _nx  = lengthdir_x(1, beam_angle), _ny = lengthdir_y(1, beam_angle);   // across the beam
    for (var _d = 0; _d < _len; _d += _sh * beam_scale)
    {
        var _ph = min(_sh, (_len - _d) / beam_scale);
        var _tx = _sx + bdx * _d - _nx * (_sw / 2) * _xs;   // the piece's top-left corner
        var _ty = _sy + bdy * _d - _ny * (_sw / 2) * _xs;
        draw_sprite_general(_spr, _img, 0, 0, _sw, _ph, _tx, _ty, _xs, beam_scale, beam_angle,
                            c_white, c_white, c_white, c_white, 1);
    }
}

shield_crack = function()
{
    var _a = random_range(-shield_arc * 0.85, shield_arc * 0.85);
    var _pts = [[_a, -shield_th / 2]];
    for (var k = 1; k <= 3; k++) array_push(_pts, [_a + random_range(-4, 4), -shield_th / 2 + shield_th * k / 3]);
    array_push(shield.cracks, _pts);
    shield.flash = max(shield.flash, 0.6);
    play(crack_sound, 0.6, 0, random_range(0.9, 1.15));
}

