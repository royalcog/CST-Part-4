st++;
anim_t++;

switch (state)
{
    case "wait_fade":   // until the fade-in's done
        if (instance_exists(obj_cutscenefade) && obj_cutscenefade.fade_alpha > 0) st = 0;
        else if (st >= start_wait) { create_textbox("rm3_1"); go("talk1"); }
    break;

    case "talk1":
        if (!instance_exists(obj_textbox)) { pose(lancer, lancer_turn_sprite); go("turn1"); }   // Lancer turns around
    break;

    case "turn1":
        if (st >= turn_wait) { create_textbox("rm3_2"); go("talk2"); }
    break;

    case "talk2":
        if (!instance_exists(obj_textbox)) { pose(queen, queen_turn_sprite); go("turn2"); }     // Queen turns around
    break;

    case "turn2":
        if (st >= turn_wait)
        {
            cam_from = get_cam_y();
            cam_to   = town_top;
            if (mini_hum != noone)
            {
                snd_hum = audio_play_sound(mini_hum, 1, true, 0);
                audio_sound_gain(snd_hum, mini_hum_gain, pan_up_time / game_get_speed(gamespeed_fps) * 1000);
            }
            go("pan_up");
        }
    break;

    case "pan_up":
    {
        var _k = clamp(st / pan_up_time, 0, 1);
        set_cam_y(lerp(cam_from, cam_to, ease(_k)));
        if (_k >= 1) go("hold");
    }
    break;

    case "hold":
        if (st >= pan_hold)
        {
            cam_from = get_cam_y();
            cam_to   = cam_home_y;
            if (snd_hum >= 0) audio_sound_gain(snd_hum, 0, pan_down_time / game_get_speed(gamespeed_fps) * 1000);
            go("pan_down");
        }
    break;

    case "pan_down":
    {
        var _k = clamp(st / pan_down_time, 0, 1);
        set_cam_y(lerp(cam_from, cam_to, ease(_k)));
        if (_k >= 1) { create_textbox("rm3_3"); go("talk3"); }
    }
    break;

    case "talk3":
        if (!instance_exists(obj_textbox))
        {
            pose(lancer, spr_lancer_up);
            pose(queen,  spr_queen_walk_up, 1);
            go("leave");
        }
    break;

    case "leave":   // they head off, and it fades to the ending
        if (instance_exists(lancer)) lancer.y -= walk_speed;
        if (instance_exists(queen))  queen.y  -= walk_speed;
        if (st == walk_frames)
        {
            global.titan_ending = true;   // rm_zero starts obj_rm_zero_ending
            var _f = instance_create_depth(0, 0, -9999, obj_cutscenefade);
            _f.fade_target   = 1;
            _f.fade_alpha    = 0;
            _f.target_room   = rm_zero;
            _f.wait_duration = 30;
        }
    break;
}