// ===================================================================
// The end of the Knight fight. The cutscene itself is round 13's
// dialogue (scr_knight_finale_batch); this object does the parts
// dialogue can't: the swoon barrage, Ralsei's barrier, King's spades,
// the Knight leaving, Susie's counter + heal beam, running inside.
// Each part is an "action": play("name") starts it, busy goes false when it's done.
// ===================================================================
depth = -3500; // in front of everyone, behind the TALKbox

// --- tuning ---
swoon_gain    = 5;
zero_color    = make_color_rgb(255, 0, 255);
ralsei_color  = make_color_rgb(1, 255, 0);

// Susie blocking, faster and faster. dur = how long the swoon covers the screen, gap = beat before the next
rapid_hits = [
    { dur: 50, gap: 26 }, { dur: 38, gap: 18 }, { dur: 28, gap: 12 },
    { dur: 20, gap: 9 },  { dur: 14, gap: 6 },  { dur: 10, gap: 4 }
];

// Ralsei's barrier (a wall of light in front of both of them)
ralsei_cast_frame = 4;
barrier_gap       = 22;  // px in front of whoever's further forward
barrier_w         = 8;
barrier_pad_top   = 18;
barrier_pad_bot   = 6;
barrier_grow      = 16;  // frames to grow in

// the barrage on the barrier: each swoon cuts into the last one
barrage_count = 20;
barrage_int_a = 26;  barrage_int_b = 5;  // frames between swoons, first -> last
barrage_hold  = 40;  // after the last hit

// King comes over and throws
king_walk_dist  = 150;
king_walk_speed = 3;
king_wind       = 20;   // frames he holds before throwing
king_hand_x     = -22;  // where the spade leaves from, from the middle of his body
king_hand_y     = -8;
spade_speed     = 18;
spade_gap       = 8;    // frames between the two spades
spade_spin      = 25;   // degrees per frame
spade_scale     = 1.5;
shard_count     = 16;

// the Knight leaving: back into the ball, into the castle door
leave_frames     = 100;
leave_end_scale  = 0.3;
door_off_x       = 0;   // the emblem on the castle, from obj_castle_tutorial_area's position
door_off_y       = 22;
castle_base_off  = 80;  // the castle's bottom edge, from obj_castle_tutorial_area's y

// Susie gets up
struggle_frames  = 50;
getup_walk_dist  = 48;
getup_walk_speed = 1;

// King throws at Susie, she blocks and Rude Busters him
counter_spade_speed = 13;
defend_at_dist      = 90;  // she snaps into her guard when the spade's this close
buster_delay        = 25;
push_dist           = 30;
push_frames         = 14;
king_hurt_hold      = 40;

// the heal beam
heal_frame  = 14;          // frame of spr_susie_heal the beam leaves on
beam_speed  = 6;
beam_scale  = 2;
hand_off_x  = -14;         // where the beam leaves from, from the middle of Susie's body
hand_off_y  = -10;

// running inside
run_speed       = 3.5;
run_fade_px     = 30;   // fades out over the last this-many px before the castle
ralsei_run_wait = 12;   // he starts a beat after her

// --- state ---
action   = "";
busy     = false;
sub      = "";
t        = 0;   // frames in this sub-step
idx      = 0;
swoon_on = noone;
saved    = {};

barrier  = { on: false, broken: false, x1: 0, y1: 0, x2: 0, y2: 0, grow: 0, flash: 0, t: 0, cracks: [] };
shards   = [];
spades   = [];
chunks   = [];
ball     = { on: false, x: 0, y: 0, sx: 0, sy: 0, tx: 0, ty: 0, t: 0, frame: 0, xs: 1, scale: 2, alpha: 1 };
beam     = { on: false, x: 0, y: 0, tx: 0, ty: 0, dir: 0, frame: 0, trail: [] };
buster   = noone;
charge_snd = -1;
runners  = [];

// ------------------------------------------------------------ helpers

play = function(_name)
{
    action = _name;
    busy   = true;
    sub    = "start";
    t      = 0;
    idx    = 0;
}

go     = function(_sub) { sub = _sub; t = 0; }
finish = function() { action = ""; busy = false; sub = ""; }

/// swaps a sprite keeping the visible body planted
pose = function(_o, _spr, _loop)
{
    if (instance_exists(_o)) scr_set_battle_sprite(_o, _spr, _spr, _loop);
}

/// middle of an instance's visible pixels
body_mid = function(_o)
{
    with (_o)
    {
        return {
            x: x + ((sprite_get_bbox_left(sprite_index) + sprite_get_bbox_right(sprite_index) + 1) / 2 - sprite_get_xoffset(sprite_index)) * image_xscale,
            y: y + ((sprite_get_bbox_top(sprite_index) + sprite_get_bbox_bottom(sprite_index) + 1) / 2 - sprite_get_yoffset(sprite_index)) * image_yscale
        };
    }
    return { x: 0, y: 0 };
}

/// visible edges of an instance
body_rect = function(_o)
{
    with (_o)
    {
        var _ax = x + (sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index)) * image_xscale;
        var _bx = x + (sprite_get_bbox_right(sprite_index) + 1 - sprite_get_xoffset(sprite_index)) * image_xscale;
        var _ay = y + (sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index)) * image_yscale;
        var _by = y + (sprite_get_bbox_bottom(sprite_index) + 1 - sprite_get_yoffset(sprite_index)) * image_yscale;
        return { x1: min(_ax, _bx), x2: max(_ax, _bx), y1: min(_ay, _by), y2: max(_ay, _by) };
    }
    return undefined;
}

/// a new swoon cuts off whatever swoon is still up
swoon = function(_spr, _dur)
{
    with (obj_swoon) instance_destroy();
    swoon_on = scr_swoon(_spr, _dur, undefined, swoon_gain);
    return swoon_on;
}

/// the "0" over Susie when she blocks (same spot as the round 2 block)
zero_popup = function(_o)
{
    if (!instance_exists(_o)) return;
    var _b = scr_get_body(_o);
    var _h = (sprite_get_bbox_bottom(_o.sprite_index) - sprite_get_bbox_top(_o.sprite_index)) * _o.image_yscale;
    scr_trigger_damage_popup(_o, 0, zero_color, zero_color, _b.x - _o.x, _b.y - _o.y - _h * 0.6);
}

/// "SWOON" over someone's head
swoon_popup = function(_o)
{
    with (obj_battle_ui_box) if (body == _o) { scr_party_swoon_popup(id); break; }
}

door_point = function()
{
    if (instance_exists(obj_castle_tutorial_area))
        return { x: obj_castle_tutorial_area.x + door_off_x, y: obj_castle_tutorial_area.y + door_off_y };
    return { x: room_width / 2, y: 260 };
}

castle_base_y = function()
{
    if (instance_exists(obj_castle_tutorial_area)) return obj_castle_tutorial_area.y + castle_base_off;
    return 320;
}

// ------------------------------------------------------------ barrier

barrier_build = function()
{
    var _r = [];
    if (instance_exists(obj_susie))  array_push(_r, body_rect(obj_susie));
    if (instance_exists(obj_ralsei)) array_push(_r, body_rect(obj_ralsei));
    if (array_length(_r) == 0) return;

    var _right = -100000, _top = 100000, _bot = -100000;
    for (var i = 0; i < array_length(_r); i++)
    {
        _right = max(_right, _r[i].x2);
        _top   = min(_top, _r[i].y1);
        _bot   = max(_bot, _r[i].y2);
    }
    barrier.x1 = _right + barrier_gap;
    barrier.x2 = barrier.x1 + barrier_w;
    barrier.y1 = _top - barrier_pad_top;
    barrier.y2 = _bot + barrier_pad_bot;
    barrier.on = true;
    barrier.broken = false;
    barrier.grow = 0;
    barrier.cracks = [];
}

barrier_hit = function()
{
    if (!barrier.on || barrier.broken) return;
    barrier.flash = 1;
    // a crack somewhere on it
    var _cx = random_range(barrier.x1, barrier.x2);
    var _cy = random_range(barrier.y1 + 6, barrier.y2 - 6);
    var _a  = random(360), _l = random_range(6, 16);
    array_push(barrier.cracks, { x1: _cx - lengthdir_x(_l, _a), y1: _cy - lengthdir_y(_l, _a), x2: _cx + lengthdir_x(_l, _a), y2: _cy + lengthdir_y(_l, _a) });
    var _s = audio_play_sound(snd_impact, 1, false);
    audio_sound_pitch(_s, random_range(0.9, 1.15));
    scr_camera_shake(3, 8);
}

barrier_shatter = function()
{
    if (!barrier.on || barrier.broken) return;
    barrier.broken = true;
    barrier.on = false;
    for (var i = 0; i < shard_count; i++)
    {
        array_push(shards, { x: random_range(barrier.x1, barrier.x2), y: random_range(barrier.y1, barrier.y2),
                             vx: random_range(-4, -0.5), vy: random_range(-3, 1), rot: random(360), vr: random_range(-12, 12),
                             len: random_range(4, 10), t: 0 });
    }
    audio_play_sound(snd_glassbreak, 1, false);
    audio_play_sound(snd_impact, 1, false);
    scr_camera_shake(6, 20);
}

// ------------------------------------------------------------ spades

/// a spade from King's hand to _target. _on_hit() runs when it lands
throw_spade = function(_target, _speed, _on_hit)
{
    if (!instance_exists(obj_king) || !instance_exists(_target)) return;
    var _k = body_mid(obj_king);
    var _x = _k.x + king_hand_x, _y = _k.y + king_hand_y;
    array_push(spades, { x: _x, y: _y, target: _target, speed: _speed, rot: 0, on_hit: _on_hit });
    audio_play_sound(snd_swing, 1, false);
}

spade_break = function(_x, _y)
{
    for (var i = 0; i < 5; i++)
    {
        array_push(chunks, { x: _x, y: _y, vx: random_range(1, 4), vy: random_range(-4, -1), rot: random(360), vr: random_range(-15, 15), t: 0 });
    }
}