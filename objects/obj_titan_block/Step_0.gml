t++;
var _sec = t / fps_;
var _cam = view_camera[0];
var _vx  = camera_get_view_x(_cam);
var _vy  = camera_get_view_y(_cam);
var _vh  = camera_get_view_height(_cam);

flash = max(0, flash - 1 / (flash_time * fps_));
if (beam_on) beam_t++;

// ---------------------------------------------------------------- the shield goes up, the beam hits it
if (_sec >= react_at && once("react") && instance_exists(obj_ralsei))
{
    obj_ralsei.sprite_index = ralsei_react_sprite;
    obj_ralsei.image_index  = 0;
    obj_ralsei.image_speed  = 0;
}
if (_sec >= cast_at && once("cast") && instance_exists(obj_ralsei))
{
    obj_ralsei.sprite_index = ralsei_cast_sprite;
    obj_ralsei.image_index  = 0;
    obj_ralsei.image_speed  = 1;
    obj_ralsei.anim_loop    = false;   // holds the spell up on its last frame
    play(cast_sound);
}
if (_sec >= shield_at && once("shield"))
{
    shield_build();
    play(shield_sound);
}
if (_sec >= slam_at && once("slam"))
{
    beam_on = true;
    flash = flash_amt;
    shield.flash = 1;
    play(blast_sound, 1, blast_offset);
}
if (_sec >= slam_at + hum_delay && once("hum"))
{
    snd_hum = play(hum_sound, 0, 0, 1, true);
    if (snd_hum >= 0) audio_sound_gain(snd_hum, hum_gain, 500);
}

// the shield holding the beam back, getting shoved down
if (shield.on)
{
    shield.t++;
    shield.grow  = min(1, shield.grow + 1 / (shield_grow * fps_));
    shield.flash = max(0, shield.flash - 0.08);
    if (beam_on)
    {
        shield.push = min(push_max, shield.push + push_speed / fps_);
        shield.jx = random_range(-push_jitter, push_jitter);
        shield.jy = random_range(-push_jitter, push_jitter);
        if (++crack_t >= crack_every * fps_) { crack_t = 0; shield_crack(); }

        var _top = shield_point(0, shield_th / 2);
        beam_ex = _top.x;
        beam_ey = _top.y;
        repeat (spark_rate)
            array_push(sparks, { x: _top.x + random_range(-24, 24), y: _top.y,
                                 vx: choose(-1, 1) * random_range(2, 6), vy: random_range(-4, -0.5),
                                 t: 0, life: irandom_range(12, 24) });
    }
}

// ---------------------------------------------------------------- the Knight
if (instance_exists(scene) && instance_exists(scene.knight))
{
    var _k = scene.knight;

    if (_sec >= knight_down_at && once("knight_down"))
    {
        _k.visible = true;
        var _c = knight_center();
        knight_x0     = _c.x;
        knight_from_y = _c.y;
        knight_to_y   = party_feet_y + knight_level_dy;
        kstate = "down";
        kt = 0;
    }

    switch (kstate)
    {
        case "down":   // down to their level
        {
            kt++;
            var _e = clamp(kt / (knight_down_time * fps_), 0, 1);
            _e = _e * _e * (3 - 2 * _e);
            knight_place(knight_x0, lerp(knight_from_y, knight_to_y, _e));
            if (_e >= 1) { kstate = "wait"; kt = 0; }
        }
        break;

        case "wait":   // a beat, then his flying form, facing them
            if (++kt >= knight_transform_gap * fps_)
            {
                var _c = knight_center();
                _k.sprite_index = spr_knight_fly_transition;
                _k.image_index  = 0;
                _k.image_speed  = 1;
                _k.anim_loop    = false;
                _k.image_xscale = -abs(_k.image_xscale);   // they're to his left
                knight_place(_c.x, _c.y);
                play(transform_sound);
                kstate = "transform";
                kt = 0;
            }
        break;

        case "transform":
            if (_k.image_speed == 0 || _k.image_index >= _k.image_number - 1) { kstate = "pre_fly"; kt = 0; }
        break;

        case "pre_fly":
            if (++kt >= knight_fly_gap * fps_)
            {
                var _c = knight_center();
                _k.sprite_index = spr_knight_fly;
                _k.image_index  = 0;
                _k.image_speed  = 1;
                _k.anim_loop    = true;
                knight_place(_c.x, _c.y);
                scene.bob_amp = 0;   // no floating while he zooms
                play(zoom_sound);
                kstate = "fly";
                kt = 0;
            }
        break;

        case "fly":   // zooms left through them and off-screen
        {
            kt++;
            _k.x -= knight_fly_speed;
            if (kt mod knight_trail_every == 0)
            {
                var _sh = instance_create_layer(_k.x, _k.y, "Instances", obj_shadow);
                _sh.spr = _k.sprite_index;  _sh.frame = _k.image_index;
                _sh.xscale = _k.image_xscale; _sh.yscale = _k.image_yscale;
                _sh.angle = _k.image_angle; _sh.alpha = 0.6;
                _sh.depth = _k.depth + 1;   _sh.drift_x = 0; _sh.drift_y = 0;
            }
            // whoever he's just passed spins
            var _c = knight_center();
            for (var i = 0; i < array_length(heroes); i++)
            {
                var _h = heroes[i];
                if (_h.phase != "stand" || !instance_exists(_h.o)) continue;
                var _f = scr_get_feet(_h.o);
                if (_c.x <= _f.x)
                {
                    _h.phase = "spin";
                    _h.t  = 0;
                    _h.fx = _f.x;
                    _h.fy = _f.y;
                }
            }
            if (_c.x < _vx - 150) { _k.visible = false; kstate = "gone"; }
        }
        break;
    }
}

// ---------------------------------------------------------------- them
for (var i = 0; i < array_length(heroes); i++)
{
    var _h = heroes[i];
    if (!instance_exists(_h.o)) continue;
    var _o = _h.o;

    switch (_h.phase)
    {
        case "spin":   // fast, slowing down
        {
            _h.t++;
            var _e = clamp(_h.t / (spin_time * fps_), 0, 1);
            var _p = spin_turns * (1 - (1 - _e) * (1 - _e));
            var _spr = _h.dirs[floor(_p * 4) mod 4];
            if (_o.sprite_index != _spr) { _o.sprite_index = _spr; _o.image_index = 0; _o.image_speed = 0; }
            set_feet(_o, _h.fx, _h.fy);
            if (_e >= 1)
            {
                _o.sprite_index = _h.dirs[0];
                _h.phase = "dizzy";
                _h.t = 0;
            }
        }
        break;

        case "dizzy":   // reeling
            _h.t++;
            set_feet(_o, _h.fx + sin(_h.t * 0.35) * dizzy_sway * (1 - _h.t / (dizzy_time * fps_)), _h.fy);
            if (_h.t >= dizzy_time * fps_) { set_feet(_o, _h.fx, _h.fy); _h.phase = "dazed"; }
        break;

        case "jump":   // away from the beam
        {
            _h.t++;
            var _e = clamp(_h.t / (jump_time * fps_), 0, 1);
            set_feet(_o, _h.fx + _h.jdir * _h.jdist * _e, _h.fy - sin(_e * pi) * jump_h);
            if (_e >= 1)
            {
                _o.sprite_index = _h.land;
                _o.image_index  = 0;
                _o.image_speed  = 0;
                _o.image_xscale = abs(_o.image_xscale) * (-_h.jdir) * _h.native;   // facing the beam
                _h.phase = "landed";
            }
        }
        break;

        case "landed":
            set_feet(_o, _h.fx + _h.jdir * _h.jdist, _h.fy);
        break;
    }
}

// ---------------------------------------------------------------- "Watch out!" and the jump
switch (state)
{
    case "wait":   // until they've both stopped reeling
    {
        var _ready = (array_length(heroes) > 0);
        for (var i = 0; i < array_length(heroes); i++)
            if (instance_exists(heroes[i].o) && heroes[i].phase != "dazed") _ready = false;
        if (_ready && once("dazed")) dazed_t = t;
        if (_ready && t - dazed_t >= watchout_wait * fps_)
        {
            create_textbox(watchout_text);
            state = "talk";
        }
    }
    break;

    case "talk":
        if (!instance_exists(obj_textbox))
        {
            // they jump clear, the shield breaks and the beam hits where they were
            shield_shatter();
            beam_ey = _vy + _vh + 40;
            beam_ex = line_x(beam_ey);
            flash = flash_amt;
            play(break_sound);
            play(blast_sound, 1, blast_offset);
            for (var i = 0; i < array_length(heroes); i++)
            {
                var _h = heroes[i];
                if (!instance_exists(_h.o)) continue;
                var _f = scr_get_feet(_h.o);
                _h.fx = _f.x;
                _h.fy = _f.y;
                _h.jdir = (_f.x < line_x(_f.y)) ? -1 : 1;   // away from the beam where it hits their level
                _h.o.sprite_index = _h.air;
                _h.o.image_index  = 0;
                _h.o.image_speed  = 0;
                _h.phase = "jump";
                _h.t = 0;
            }
            state = "beam_out";
            st = 0;
        }
    break;

    case "beam_out":
    {
        st++;
        var _a = beam_after * fps_;
        if (st > _a) beam_w = max(0, 1 - (st - _a) / (beam_thin * fps_));
        if (st >= _a && once("hum_out") && snd_hum >= 0) audio_sound_gain(snd_hum, 0, (beam_thin + 0.3) * 1000);
        if (beam_w <= 0) { beam_on = false; state = "done"; }
    }
    break;

    case "done":
        // next: whatever comes after (the party's dialogue in the game)
    break;
}

// ---------------------------------------------------------------- bits
for (var i = array_length(shards) - 1; i >= 0; i--)
{
    var _p = shards[i];
    _p.t++;
    _p.vy += 0.25;
    _p.x += _p.vx;
    _p.y += _p.vy;
    _p.rot += _p.vr;
    if (_p.t >= 45) array_delete(shards, i, 1);
}
for (var i = array_length(sparks) - 1; i >= 0; i--)
{
    var _p = sparks[i];
    _p.t++;
    _p.vy += 0.2;
    _p.x += _p.vx;
    _p.y += _p.vy;
    if (_p.t >= _p.life) array_delete(sparks, i, 1);
}