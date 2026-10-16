var _fps = game_get_speed(gamespeed_fps);

// the master clock: seconds since the swords hit, read off the fountain sound
if (t_all == 0)
{
    snd_fountain = play_snd(fountain_sound);
    scr_camera_shake(impact_shake, 15);
}
t_all++;
var _clock = snd_pos(snd_fountain, t_all);

if (flash > 0) flash = max(0, flash - 1 / flash_fade);
if (show_geyser)  loop_frame += sprite_get_speed(spr_titan_fountain_loop) / _fps;
if (beam_looping) beam_frame += sprite_get_speed(spr_titanbeam_loop) / _fps;
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
if (!pan1_done && _clock >= pan1_at)
{
    var _k = clamp((_clock - pan1_at) / pan1_time, 0, 1);
    set_cam_y(cam_home_y - pan1_dist * _k * _k * (3 - 2 * _k));
    if (_k >= 1) pan1_done = true;
}

// the blast: build-up, then the hum fades in under its tail
if (snd_blast >= 0 || blast_t > 0)
{
    blast_t++;
    if (snd_hum < 0 && hum_sound != noone
        && (snd_pos(snd_blast, blast_t) >= hum_at || (snd_blast >= 0 && !audio_is_playing(snd_blast))))
    {
        snd_hum = play_snd(hum_sound, true);
        audio_sound_gain(snd_hum, 0, 0);
        audio_sound_gain(snd_hum, 1, hum_fade);
    }
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

switch (state)
{
    case "pool":
        // the swords hit: the pool flashes white and fades to black
        pool_white = 1 - clamp(_clock / pool_flash_fade, 0, 1);
        if (_clock >= burst_at)
        {
            pool_white = 0;
            show_burst = true;
            frame = 0;
            state = "burst";
        }
    break;

    case "burst":
    {
        frame = (_clock - burst_at) * sprite_get_speed(spr_titan_fountain_burst);
        var _n = sprite_get_number(spr_titan_fountain_burst);

        // its last frame is the full column: that's the slam
        if (frame >= _n - 1)
        {
            scr_camera_shake(burst_shake, 20);
            flash = 0.5;
            if (instance_exists(obj_dark_fountain)) obj_dark_fountain.visible = false;
            show_burst  = false;
            show_geyser = true;
            loop_frame  = 0;
            state = "geyser";
        }
    }
    break;

    case "geyser":
        scr_camera_shake(loop_shake, 2);
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
        // the blast builds, and the shell cracks right on its hit
        if (snd_blast < 0 && blast_t == 0 && _clock >= shatter_at - blast_hit)
        {
            snd_blast = play_snd(blast_sound);
            blast_t = 1;
        }
        if (blast_t > 0) scr_camera_shake(shatter_shake * clamp(snd_pos(snd_blast, blast_t) / blast_hit, 0, 1), 2);

        if (blast_t > 0 && snd_pos(snd_blast, blast_t) >= blast_hit)
        {
            scr_camera_shake(burst_shake, 15);
            // start the crack at the bottom of the screen (whatever's under it is already grey)
            var _view_bottom = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]);
            front_y = min(base_bottom_y, _view_bottom + 10);
            state = "shatter";
        }
    break;

    case "shatter":
    {
        scr_camera_shake(shatter_shake, 2);
        front_y -= shatter_speed;

        // chunks breaking off the shell along the crack
        var _hw = sprite_get_width(spr_fountain) * dark_scale / 2;
        repeat (debris_rate)
        {
            var _side = random_range(-1, 1);
            var _sz   = random_range(3, 8);
            array_push(debris, {
                x: fx + _side * _hw,
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

        if (front_y <= tower_top_y)
        {
            front_y = tower_top_y;
            state = "settle";
            t = 0;
        }
    }
    break;

    case "settle":
        if (++t >= settle_time)
        {
            cam_from = get_cam_y();
            cam_to   = tower_top_y - beam_rise - pan_margin;
            state = "pan_up";
            t = 0;
        }
    break;

    case "pan_up":
    {
        t++;
        var _k = clamp(t / pan_up_time, 0, 1);
        set_cam_y(lerp(cam_from, cam_to, _k * _k * (3 - 2 * _k)));
        if (_k >= 1)
        {
            play_snd(ring_sound);
            show_beam = true;
            beam_looping = false;
            frame = 0;
            state = "beam_start";
            t = 0;
        }
    }
    break;

    case "beam_start":
    {
        var _last = frame;
        frame += sprite_get_speed(spr_tower_titanbeam_start) / _fps;

        if (_last < beam_flash_frame && frame >= beam_flash_frame)
        {
            play_snd(beam_flash_sound);
            scr_camera_shake(burst_shake, 25);
            flash = 0.8;
        }

        if (frame >= sprite_get_number(spr_tower_titanbeam_start))
        {
            beam_looping = true;
            beam_frame = 0;
            state = "beam_hold";
            t = 0;
        }
    }
    break;

    case "beam_hold":
        if (++t >= beam_hold)
        {
            if (snd_hum >= 0) audio_sound_gain(snd_hum, hum_far_gain, pan_down_time / _fps * 1000);
            cam_from = get_cam_y();
            cam_to   = cam_home_y;
            state = "pan_down";
            t = 0;
        }
    break;

    case "pan_down":
    {
        t++;
        var _k = clamp(t / pan_down_time, 0, 1);
        set_cam_y(lerp(cam_from, cam_to, _k * _k * (3 - 2 * _k)));
        if (_k >= 1)
        {
            state = "hand_wait";
            t = 0;
        }
    }
    break;

    case "hand_wait":
        if (++t >= hand_wait)
        {
            play_snd(hand_sound);
            scr_camera_shake(burst_shake, 25);
            flash = 0.6;
            show_hand = true;
            hand_reveal = 0;
            hand_frame = 0;
            state = "hand";
            t = 0;
        }
    break;

    case "hand":
        hand_reveal = min(1, hand_reveal + 1 / hand_emerge);
        hand_frame += sprite_get_speed(spr_tower_titanhand) / _fps;
        if (hand_frame >= sprite_get_number(spr_tower_titanhand) - 1)
        {
            hand_frame = sprite_get_number(spr_tower_titanhand) - 1;
            state = "done";
        }
    break;

    case "done":
        // whatever comes next goes here
    break;
}