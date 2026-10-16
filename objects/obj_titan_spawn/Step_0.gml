var _fps = game_get_speed(gamespeed_fps);

if (flash > 0) flash = max(0, flash - 1 / flash_fade);
if (show_geyser)  loop_frame += sprite_get_speed(spr_titan_fountain_loop) / _fps;
if (beam_looping) beam_frame += sprite_get_speed(spr_titanbeam_loop) / _fps;

switch (state)
{
    case "wait":
        if (++t >= start_delay)
        {
            play_snd(rumble_sound);
            state = "rumble";
            t = 0;
        }
    break;

    case "rumble":
        t++;
        scr_camera_shake(rumble_max * t / rumble_time, 2);
        if (t >= rumble_time)
        {
            play_snd(burst_sound);
            show_burst = true;
            frame = 0;
            state = "burst";
            t = 0;
        }
    break;

    case "burst":
    {
        var _last = frame;
        frame += sprite_get_speed(spr_titan_fountain_burst) / _fps;

        if (frame < column_frame) scr_camera_shake(rumble_max, 2);

        // the column slams up: the old fountain's hidden behind it from here
        if (_last < column_frame && frame >= column_frame)
        {
            play_snd(column_sound);
            scr_camera_shake(burst_shake, 20);
            flash = 0.5;
            if (instance_exists(obj_dark_fountain)) obj_dark_fountain.visible = false;
        }

        if (frame >= sprite_get_number(spr_titan_fountain_burst))
        {
            show_burst  = false;
            show_geyser = true;
            loop_frame  = 0;
            state = "loop";
            t = 0;
        }
    }
    break;

    case "loop":
        scr_camera_shake(loop_shake, 2);
        if (++t >= loop_time)
        {
            // it hardens
            play_snd(harden_sound);
            scr_camera_shake(burst_shake, 15);
            flash      = 1;
            pool_white = 1;
            hardening  = true;
            state = "harden";
            t = 0;
        }
    break;

    case "harden":
    {
        t++;
        var _k = clamp(t / harden_time, 0, 1);
        stone_y    = lerp(base_bottom_y, tower_top_y, _k * _k); // starts slow, picks up speed
        pool_white = 1 - _k;

        if (_k >= 1)
        {
            show_geyser = false;
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
            play_snd(beam_sound);
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
            // it bursts out of the pillar
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
            hand_frame = sprite_get_number(spr_tower_titanhand) - 1; // hold the last frame
            state = "done";
        }
    break;

    case "done":
        // whatever comes next goes here
    break;
}