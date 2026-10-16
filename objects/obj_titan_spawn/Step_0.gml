var _fps = game_get_speed(gamespeed_fps);

// the clock: seconds into the fountain sound
t_all++;
var _clock = snd_pos(snd_fountain, t_all);

if (flash > 0) flash = max(0, flash - 1 / flash_fade);
if (show_geyser) loop_frame += sprite_get_speed(spr_titan_fountain_loop) / _fps;
if (petrified)
{
    dark_scroll  += dark_scroll_spd;
    dark_scroll2 += dark_scroll_spd2;
}
if (cyan_line > 0) cyan_line = max(0, cyan_line - 1 / cyan_line_time);

// the Knight getting out of the way
if (!knight_moved && _clock >= knight_move_at) start_knight_move();
if (knight_moving)
{
    if (instance_exists(scene) && instance_exists(scene.knight))
    {
        knight_t++;
        var _k = clamp(knight_t / knight_move_time, 0, 1);
        _k = 1 - power(1 - _k, 3); // darts off, then settles
        scene.knight.x  = lerp(knight_from_x,  knight_from_x  + (knight_aside_x - fx), _k);
        scene.knight_y0 = lerp(knight_from_y0, knight_from_y0 + knight_aside_dy, _k);
        if (_k >= 1) knight_moving = false;
    }
    else knight_moving = false;
}

// the camera rising up the geyser
if (!pan_done && _clock >= pan_at)
{
    var _k = clamp((_clock - pan_at) / pan_time, 0, 1);
    set_cam_y(cam_home_y - pan_dist * _k * _k * (3 - 2 * _k));
    if (_k >= 1) pan_done = true;
}

// debris from the shell
for (var i = array_length(debris) - 1; i >= 0; i--)
{
    var _d = debris[i];
    _d.vy  += debris_grav;
    _d.x   += _d.vx;
    _d.y   += _d.vy;
    _d.rot += _d.vrot;
    _d.life--;
    _d.alpha = min(1, _d.life / 15);
    if (_d.life <= 0) array_delete(debris, i, 1);
}

// the laser runs off its own sound
if (show_laser)
{
    laser_t++;
    var _lp = snd_pos(snd_laser, laser_t);

    if (!laser_looping)
    {
        var _last = frame;
        // the charge ring builds slowly and bursts on the sound's hit
        if (_lp < laser_flash_time) frame = beam_flash_frame * (_lp / laser_flash_time);
        else                        frame = beam_flash_frame + (_lp - laser_flash_time) * sprite_get_speed(spr_tower_titanbeam_start);

        if (_last < beam_flash_frame && frame >= beam_flash_frame) flash = laser_flash;

        if (frame >= sprite_get_number(spr_tower_titanbeam_start))
        {
            laser_looping = true;
            laser_frame = 0;
        }
    }
    else laser_frame += sprite_get_speed(spr_titanbeam_loop) / _fps;

    if (snd_hum < 0 && hum_sound != noone && (_lp >= hum_at || (snd_laser >= 0 && !audio_is_playing(snd_laser))))
    {
        snd_hum = play_snd(hum_sound, true);
        audio_sound_gain(snd_hum, 0, 0);
        audio_sound_gain(snd_hum, 1, hum_fade);
    }
}

switch (state)
{
    case "pool":
        // the swords hit: the pool flashes white and fades to black
        pool_white = 1 - clamp((_clock - pool_flash_start) / pool_flash_fade, 0, 1);
        if (_clock >= burst_at)
        {
            pool_white = 0;
            show_burst = true;
            state = "burst";
        }
    break;

    case "burst":
        frame = (_clock - burst_at) * sprite_get_speed(spr_titan_fountain_burst);
        // its last frame is the full column
        if (frame >= sprite_get_number(spr_titan_fountain_burst) - 1)
        {
            flash = column_flash;
            if (instance_exists(obj_dark_fountain)) obj_dark_fountain.visible = false;
            show_burst  = false;
            show_geyser = true;
            loop_frame  = 0;
            state = "geyser";
        }
    break;

    case "geyser":
        if (_clock >= petrify_at)
        {
            // hard cut to dark stone
            play_snd(petrify_sound);
            show_geyser = false;
            show_pool   = false;
            petrified   = true;
            cyan_line   = 1;
            front_y     = base_bottom_y;
            state = "petrified";
        }
    break;

    case "petrified":
        if (_clock >= shatter_at)
        {
            // the crack climbs from the bottom of the screen to past the top
            var _vt = camera_get_view_y(view_camera[0]);
            front_from = min(base_bottom_y, _vt + camera_get_view_height(view_camera[0]) + 10);
            front_to   = _vt - 40;
            shattering = true;
            state = "shatter";
        }
    break;

    case "shatter":
    {
        var _k = clamp((_clock - shatter_at) / (shatter_end - shatter_at), 0, 1);
        front_y = lerp(front_from, front_to, _k);

        repeat (debris_rate)
        {
            var _side = random_range(-1, 1);
            var _sz   = random_range(3, 8);
            array_push(debris, {
                x: fx + _side * pillar_half,
                y: front_y + random_range(-6, 10),
                vx: _side * random_range(0.5, 3),
                vy: random_range(-3.5, -0.5),
                rot: random(360),
                vrot: random_range(-10, 10),
                r1: _sz * random_range(0.6, 1),
                r2: _sz * random_range(0.6, 1),
                r3: _sz * random_range(0.6, 1),
                col: choose(debris_dark, debris_dark, debris_light),
                life: irandom_range(30, 60),
                alpha: 1
            });
        }

        if (_k >= 1)
        {
            shattering = false;
            front_y = -100000; // all grey now
            state = "hand_wait";
        }
    }
    break;

    case "hand_wait":
        if (_clock >= hand_at)
        {
            // it bursts out of the pillar's right side
            play_snd(hand_sound);
            flash = hand_flash;
            hand_y = camera_get_view_y(view_camera[0]) + hand_top_gap;
            show_hand = true;
            state = "hand";
        }
    break;

    case "hand":
    {
        var _ht = _clock - hand_at;
        var _last_frame = sprite_get_number(spr_tower_titanhand) - 1;
        hand_reveal = clamp(_ht / hand_emerge, 0, 1);
        hand_frame  = min(_ht * sprite_get_speed(spr_tower_titanhand), _last_frame);

        if (hand_frame >= _last_frame)
        {
            laser_at = _clock + laser_gap;
            state = "laser_wait";
        }
    }
    break;

    case "laser_wait":
        if (_clock >= laser_at)
        {
            snd_laser = play_snd(laser_sound);
            laser_t = 0;
            frame = 0;
            laser_looping = false;
            show_laser = true;
            state = "done";
        }
    break;

    case "done":
        // the laser keeps firing; whatever comes next goes here
    break;
}