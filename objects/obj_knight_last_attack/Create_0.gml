// ===================================================================
// Knight attack 13: the last one. Everything the Knight's done, while
// darkness closes in: the box keeps shrinking, the corners go dark
// (touching them hurts, and light blue can't move into them), the
// party trades the soul's colour back and forth faster and faster,
// and it ends on one huge X cut through the middle of the box.
//   red (the Knight) -> light blue (Susie) -> green (Ralsei) -> all of them -> the X
// ===================================================================

scr_slashes_init();   // the Knight's cuts + his swing
scr_soul_swap_init(); // the party changing the soul's colour
slash_damage = 45;

// --- tuning ---
start_delay    = 30;

// swords (same as Prism: fly in along a lane, blocked by the shield if green, dodged otherwise)
sword_scale    = 1.2;
sword_damage   = 45;
sword_hit_r    = 7;
spawn_dist     = 300;
fade_in        = 10;
fade_out_px    = 40;
block_sound    = snd_impact;
spark_frames   = 12;
tip_off        = (sprite_get_bbox_right(spr_roaringknight_sword) + 1 - sprite_get_xoffset(spr_roaringknight_sword)) * sword_scale;
blade_len      = (sprite_get_bbox_right(spr_roaringknight_sword) - sprite_get_bbox_left(spr_roaringknight_sword) + 1) * sword_scale;

// red cuts
parallel_space = 30;

// the darkness
dark_damage    = 45;
dark_inset     = 6;    // how far inside a dark corner the soul has to be before it hurts
dark_fade      = 30;   // frames for a corner to go fully dark
dark_color     = make_color_rgb(40, 0, 60);
dark_edge      = make_color_rgb(140, 40, 200);
shrink_sound   = snd_impact;

// the X
x_charge       = 90;   // warning time
x_cut_width    = 30;
x_shake        = 8;

// the flash at the very end
flash_frames   = 45;

end_delay      = 40;

// --- state ---
state      = "intro";
timer      = start_delay;
beats      = [];
bi         = 0;
swords     = [];
sparks     = [];
dark       = array_create(9, false);  // corner sectors gone dark
dark_t     = array_create(9, 0);
last_side  = -1;
same_count = 0;
spin_side  = irandom(3);
spin_step  = choose(1, -1);
white_t    = 0;

get_soul = function() { return instance_exists(obj_soul) ? instance_find(obj_soul, 0) : noone; }

// ------------------------------------------------------------ darkness

/// one of the four corners goes dark (never the one the soul's in). false if none are left
darken_corner = function()
{
    var _s  = get_soul();
    var _b  = scr_get_attack_bounds();
    var _cw = (_b.x2 - _b.x1) / 3, _ch = (_b.y2 - _b.y1) / 3;

    // the sector the soul's in right now
    var _sc = 1, _sr = 1;
    if (instance_exists(_s))
    {
        if (_s.soul_mode == "lightblue") { _sc = _s.grid_c; _sr = _s.grid_r; }
        else
        {
            var _l = scr_world_to_box_local(_s.x, _s.y);
            _sc = clamp(floor((_l.x - _b.x1) / _cw), 0, 2);
            _sr = clamp(floor((_l.y - _b.y1) / _ch), 0, 2);
        }
    }

    var _opts = [];
    var _corners = [0, 2, 6, 8];
    for (var i = 0; i < 4; i++)
    {
        var _k = _corners[i];
        if (!dark[_k] && _k != _sc + _sr * 3) array_push(_opts, _k);
    }
    if (array_length(_opts) == 0) return false;

    var _pick = _opts[irandom(array_length(_opts) - 1)];
    dark[_pick]   = true;
    dark_t[_pick] = 0;
    var _snd = audio_play_sound(shrink_sound, 1, false);
    audio_sound_pitch(_snd, 0.6);
    scr_camera_shake(3, 12);
    return true;
}

/// the rect of sector _k (box-local coords, same as the interior)
cell_rect = function(_k)
{
    var _b  = scr_get_attack_bounds();
    var _cw = (_b.x2 - _b.x1) / 3, _ch = (_b.y2 - _b.y1) / 3;
    var _c = _k mod 3, _r = _k div 3;
    return { x1: _b.x1 + _c * _cw, y1: _b.y1 + _r * _ch, x2: _b.x1 + (_c + 1) * _cw, y2: _b.y1 + (_r + 1) * _ch };
}

shrink_box = function(_scale)
{
    if (!instance_exists(obj_battlebox)) return;
    obj_battlebox.target_scale_x = _scale;
    obj_battlebox.target_scale_y = _scale;
    var _snd = audio_play_sound(shrink_sound, 1, false);
    audio_sound_pitch(_snd, 0.5);
    scr_camera_shake(2, 15);
}

// ------------------------------------------------------------ swords

pick_side = function(_how)
{
    if (is_real(_how)) { last_side = _how; return _how; }
    if (_how == "spin")
    {
        var _sp = spin_side;
        spin_side = (spin_side + spin_step + 4) mod 4;
        last_side = _sp;
        return _sp;
    }
    if (_how == "opposite") { last_side = (last_side + 2) mod 4; return last_side; }
    if (_how == "same")     return max(last_side, 0);

    var _sd = irandom(3);
    if (_sd == last_side && same_count >= 2) _sd = (_sd + 1 + irandom(2)) mod 4;
    same_count = (_sd == last_side) ? same_count + 1 : 1;
    last_side  = _sd;
    return _sd;
}

/// sideways offset from the box's middle line. _lane: "center", "soul", "random", or -1 / 0 / 1
pick_lane = function(_side, _lane)
{
    var _b = scr_get_attack_bounds();
    var _c = scr_box_center();
    var _horiz = (_side == 0 || _side == 2);
    var _cell  = _horiz ? (_b.y2 - _b.y1) / 3 : (_b.x2 - _b.x1) / 3;
    var _s = get_soul();

    if (is_real(_lane)) return _lane * _cell;
    if (_lane == "random") return irandom_range(-1, 1) * _cell;
    if (_lane == "soul" && instance_exists(_s))
    {
        if (_s.soul_mode == "green") return 0;
        if (_s.soul_mode == "lightblue") return (_horiz ? _s.grid_r : _s.grid_c) * _cell - _cell;
        var _off = _horiz ? _s.y - _c.y : _s.x - _c.x;
        return clamp(_off, -_cell * 1.4, _cell * 1.4);
    }
    return 0;
}

spawn_sword = function(_side_how, _lane, _speed)
{
    var _side = pick_side(_side_how);
    array_push(swords, { side: _side, ang: _side * 90, lane: pick_lane(_side, _lane),
                         dist: spawn_dist, speed: _speed, t: 0, alpha: 0 });
}

sword_tip = function(_w, _c)
{
    var _x = _c.x + lengthdir_x(_w.dist, _w.ang);
    var _y = _c.y + lengthdir_y(_w.dist, _w.ang);
    if (_w.side == 0 || _w.side == 2) _y += _w.lane; else _x += _w.lane;
    return { x: _x, y: _y };
}

// ------------------------------------------------------------ cuts

spawn_red = function(_pattern, _charge)
{
    var _in = scr_get_box_interior();
    var _s  = get_soul();
    var _sx = instance_exists(_s) ? _s.x : (_in.x1 + _in.x2) / 2;
    var _sy = instance_exists(_s) ? _s.y : (_in.y1 + _in.y2) / 2;
    var _a  = irandom(179);

    switch (_pattern)
    {
        case "single":
            scr_slash_add(scr_slash_clip_line(_sx, _sy, _a, _in), _charge);
        break;
        case "cross":
            scr_slash_add(scr_slash_clip_line(_sx, _sy, _a, _in), _charge);
            scr_slash_add(scr_slash_clip_line(_sx, _sy, _a + 90, _in), _charge + 6);
        break;
        case "fan":
            for (var i = 0; i < 3; i++) scr_slash_add(scr_slash_clip_line(_sx, _sy, _a + i * 60, _in), _charge + i * 6);
        break;
        case "parallel":
            for (var i = -1; i <= 1; i++)
            {
                var _ox = lengthdir_x(parallel_space * i, _a + 90), _oy = lengthdir_y(parallel_space * i, _a + 90);
                scr_slash_add(scr_slash_clip_line(_sx + _ox, _sy + _oy, _a, _in), _charge);
            }
        break;
    }
}

/// light blue: grid cuts. the first covers the soul's sector, and at least one open (not dark) sector stays safe
spawn_blue = function(_n, _charge)
{
    var _all = scr_slash_grid_lines(scr_get_attack_bounds());
    var _s   = get_soul();
    var _sc  = instance_exists(_s) ? _s.grid_c : 1, _sr = instance_exists(_s) ? _s.grid_r : 1;

    var _covered = array_create(9, false);
    for (var c = 0; c < 9; c++) _covered[c] = dark[c]; // dark sectors were never safe
    var _picked  = [];
    var _order   = array_shuffle(array_create_ext(array_length(_all), function(_i) { return _i; }));

    for (var k = 0; k < array_length(_order) && array_length(_picked) < _n; k++)
    {
        var _cut = _all[_order[k]];
        if (array_length(_picked) == 0)
        {
            var _hits = false;
            for (var c = 0; c < 3; c++) if (_cut.cells[c][0] == _sc && _cut.cells[c][1] == _sr) _hits = true;
            if (!_hits) continue;
        }
        var _test = array_create(9, false);
        array_copy(_test, 0, _covered, 0, 9);
        for (var c = 0; c < 3; c++) _test[_cut.cells[c][0] + _cut.cells[c][1] * 3] = true;
        var _safe = 0;
        for (var c = 0; c < 9; c++) if (!_test[c]) _safe++;
        if (_safe < 1) continue;
        _covered = _test;
        array_push(_picked, _cut);
    }
    for (var k = 0; k < array_length(_picked); k++) scr_slash_add(_picked[k].seg, _charge + k * 4, _picked[k].cells);
}

/// the big finish: one huge X corner to corner through the middle. the edges of the box between its arms are safe
spawn_x = function()
{
    var _in = scr_get_box_interior();
    cut_width = x_cut_width;
    on_slash_cut = function(_sl) { scr_camera_shake(x_shake, 25); };
    scr_slash_add({ x1: _in.x1, y1: _in.y1, x2: _in.x2, y2: _in.y2 }, x_charge);
    scr_slash_add({ x1: _in.x1, y1: _in.y2, x2: _in.x2, y2: _in.y1 }, x_charge);
}

// ------------------------------------------------------------ the script
// same beat system as Prism: each beat runs, then waits `wait` frames.
// b_await waits for a colour change to land, b_clear for everything on screen to finish.

add_beat = function(_beat) { array_push(beats, _beat); }

b_mode   = function(_m, _wait)                { add_beat({ act: "mode", m: _m, wait: _wait }); }
b_red    = function(_pattern, _charge, _wait) { add_beat({ act: "red", p: _pattern, charge: _charge, wait: _wait }); }
b_blue   = function(_n, _charge, _wait)       { add_beat({ act: "blue", n: _n, charge: _charge, wait: _wait }); }
b_sword  = function(_side, _lane, _spd, _wait){ add_beat({ act: "sword", side: _side, lane: _lane, spd: _spd, wait: _wait }); }
b_swords = function(_count, _side, _lane, _spd, _gap) { repeat (_count) b_sword(_side, _lane, _spd, _gap); }
b_shrink = function(_scale, _wait)            { add_beat({ act: "shrink", s: _scale, wait: _wait }); }
b_corner = function(_wait)                    { add_beat({ act: "corner", wait: _wait }); }
b_x      = function(_wait)                    { add_beat({ act: "x", wait: _wait }); }
b_flash  = function(_wait)                    { add_beat({ act: "flash", wait: _wait }); }
b_await  = function(_wait)                    { add_beat({ act: "await", wait: _wait }); }
b_clear  = function(_wait)                    { add_beat({ act: "clear", wait: _wait }); }

// ---- 1. RED (the Knight): cuts and swords, and the box starts closing in
b_mode("red", 0);           b_await(20);
b_red("cross", 55, 50);
b_shrink(0.9, 40);
b_sword("random", "soul", 5.5, 30);
b_red("fan", 50, 55);
b_swords(2, "random", "soul", 5.5, 18);
b_red("parallel", 48, 50);
b_shrink(0.8, 30);
b_red("cross", 45, 30);
b_sword("opposite", "soul", 6, 45);
b_clear(20);

// ---- 2. LIGHT BLUE (Susie): grid cuts while the corners go dark one by one
b_mode("lightblue", 0);     b_await(20);
b_blue(1, 65, 40);          b_corner(30);
b_blue(2, 60, 50);
b_sword("random", "soul", 5.5, 30);
b_corner(30);
b_blue(2, 55, 50);
b_swords(3, "random", "random", 5.5, 20);
b_corner(30);
b_blue(2, 50, 60);
b_corner(20);
b_clear(20);

// ---- 3. GREEN (Ralsei): swords from everywhere
b_mode("green", 0);         b_await(20);
b_swords(8, "random", "center", 6, 22);
b_swords(8, "spin", "center", 6.5, 14);
b_clear(20);

// ---- 4. ALL OF THEM: the colour changes as fast as they can manage it
repeat (2)
{
    b_mode("red", 0);       b_await(5); b_red("fan", 42, 15);  b_sword("random", "soul", 6, 40);
    b_mode("lightblue", 0); b_await(5); b_blue(2, 46, 15);     b_sword("random", "soul", 6, 40);
    b_mode("green", 0);     b_await(5); b_swords(4, "spin", "center", 7, 12);
    b_clear(5);
}

// ---- 5. THE X: red, the box at its smallest, one huge cut corner to corner both ways. get between its arms
b_mode("red", 0);           b_await(10);
b_shrink(0.65, 40);
b_x(20);
b_clear(30);
b_flash(flash_frames);