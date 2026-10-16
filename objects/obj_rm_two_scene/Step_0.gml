switch (state)
{
    case "setup":
    {
        var _bottom = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) + 50;

        var _s = instance_exists(obj_susie)  ? obj_susie  : instance_create_layer(susie_x,  _bottom, "Instances", obj_susie);
        var _r = instance_exists(obj_ralsei) ? obj_ralsei : instance_create_layer(ralsei_x, _bottom, "Instances", obj_ralsei);

        _s.sprite_index = spr_susie_walk_up;
        _r.sprite_index = spr_ralsei_walk_up;

        var _pair = [ [_s, susie_x], [_r, ralsei_x] ];
        for (var i = 0; i < 2; i++)
        {
            var _o = _pair[i][0];
            _o.last_sprite = _o.sprite_index; // already placed, so scr_auto_keep_feet leaves it alone
            _o.anim_loop   = true;
            _o.image_index = 0;
            _o.image_speed = walk_anim;
            _o.image_alpha = 1;
            _o.visible     = true;
            set_feet(_o, _pair[i][1], _bottom);
        }
        state = "walk";
    }
    break;

    case "walk":
    {
        var _a = step_up(obj_susie,  stand_y);
        var _b = step_up(obj_ralsei, stand_y);
        if (_a && _b && !instance_exists(obj_cutscenefade)) { state = "pause"; t = 0; }
    }
    break;

    case "pause":
        if (++t >= talk_wait)
        {
            create_textbox("rm2_ralsei_plead");
            state = "talk";
        }
    break;

    case "talk":
        // that's all for now. cutscene_lock stays on so Z doesn't open self_4 before it exists
    break;
}