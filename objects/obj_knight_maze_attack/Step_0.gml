var _v   = view_rect();
var _hin = keyboard_check(vk_right) - keyboard_check(vk_left);
var _vin = keyboard_check(vk_down)  - keyboard_check(vk_up);
var _spd = instance_exists(obj_soul) ? obj_soul.move_speed : 2;

// pieces of the box/walls fall whatever phase we're in
for (var i = array_length(debris) - 1; i >= 0; i--)
{
    var _d = debris[i];
    _d.vy  += debris_gravity;
    _d.x   += _d.vx;
    _d.y   += _d.vy;
    _d.rot += _d.vr;
    if (_d.y > _v.y2 + 200) array_delete(debris, i, 1);
}
break_flash = max(break_flash - 0.05, 0);

switch (state)
{
    case "grow":
        if (!instance_exists(obj_battlebox)) { instance_destroy(); exit; }
        if (recenter_box) obj_battlebox.box_base_y = lerp(obj_battlebox.box_base_y, target_base_y, obj_battlebox.scale_speed);
        if (scr_box_scale_settled())
        {
            if (recenter_box) obj_battlebox.box_base_y = target_base_y;
            timer--;
            if (timer <= 0) start_maze();
        }
    break;

    case "maze":
    case "cheater_talk":
    case "buster_windup":
    case "buster_fly":
        if (!instance_exists(obj_battlebox)) { instance_destroy(); exit; }
        t++;
        wall_alpha = min(wall_alpha + 1 / wall_fade_in, 1);

        if (instance_exists(obj_soul)) move_soul(_hin * _spd, _vin * _spd);

        // the maze keeps changing until Susie's had enough
        if (state == "maze" || state == "cheater_talk")
        {
            var _sc = soul_cell();
            if (pending == undefined)
            {
                if (_sc[0] == goal_c && _sc[1] == goal_r)
                {
                    pending = build_next(_sc[0], _sc[1]); // made it — the Knight cheats
                    warn_timer = cheat_warn;
                }
                else if (t >= next_shuffle - shuffle_warn)
                {
                    pending = build_next(_sc[0], _sc[1]);
                    warn_timer = shuffle_warn;
                }
            }
            else
            {
                warn_timer--;
                if (warn_timer <= 0) swap_maze();
            }
        }

        if (!said_what && t >= what_at)
        {
            said_what = true;
            talk([ { speaker: obj_susie, text: "What the..." } ]);
        }

        if (state == "maze" && t >= cheater_at)
        {
            chain = talk([ { speaker: obj_susie, text: "You little cheater..." } ]);
            state = "cheater_talk";
        }
        else if (state == "cheater_talk" && !instance_exists(chain))
        {
            start_buster();
        }
        else if (state == "buster_windup")
        {
            if (!instance_exists(obj_susie) || obj_susie.image_index >= buster_fire_frame || obj_susie.image_speed == 0)
            {
                launch_buster();
            }
        }
        else if (state == "buster_fly")
        {
            array_insert(buster.trail, 0, { x: buster.x, y: buster.y, ang: buster.ang });
            if (array_length(buster.trail) > buster_trail_len) array_pop(buster.trail);

            buster.ang += buster_spin;
            if (point_distance(buster.x, buster.y, buster.tx, buster.ty) <= buster_speed)
            {
                break_box();
            }
            else
            {
                buster.x += lengthdir_x(buster_speed, buster.dir);
                buster.y += lengthdir_y(buster_speed, buster.dir);
            }
        }
    break;

    // box is gone: the soul flies free, an arrow points it to Susie
    case "broken":
        arrow_timer++;
        if (!instance_exists(obj_soul)) { instance_destroy(); exit; }

        obj_soul.x = clamp(obj_soul.x + _hin * _spd, _v.x1 + free_margin, _v.x2 - free_margin);
        obj_soul.y = clamp(obj_soul.y + _vin * _spd, _v.y1 + free_margin, _v.y2 - free_margin);

        if (instance_exists(obj_susie)
            && point_in_rectangle(obj_soul.x, obj_soul.y, obj_susie.bbox_left, obj_susie.bbox_top, obj_susie.bbox_right, obj_susie.bbox_bottom))
        {
            obj_soul.visible = false;
            if (absorb_sound != noone) audio_play_sound(absorb_sound, 1, false);

            flash_inst = instance_create_depth(0, 0, obj_susie.depth - 1, obj_heal_flash);
            flash_inst.target      = obj_susie.id;
            flash_inst.duration    = flash_frames;
            flash_inst.flash_color = c_white;
            state = "absorbing";
        }
    break;

    case "absorbing":
        if (!instance_exists(flash_inst))
        {
            chain = talk([
                { speaker: obj_susie, text: "I..." },
                { speaker: obj_susie, text: "I feel..." },
                { speaker: obj_susie, text: "Like you're about to have a really $#&* time." }
            ]);
            state = "final_talk";
        }
    break;

    case "final_talk":
        if (!instance_exists(chain)) instance_destroy();
    break;
}