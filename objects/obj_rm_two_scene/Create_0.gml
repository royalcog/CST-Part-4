// rm_two: Susie and Ralsei walk up to the platform's edge, the Knight floats over the fountain and beckons,
// Ralsei pleads, then the Knight summons 5 swords over his head and throws them down one at a time
global.cutscene_lock = true;

// --- tuning: Susie & Ralsei ---
edge_y     = 364;              // top edge of the floor
stand_y    = edge_y + 30;      // where their feet stop
gap        = 45;               // how far each stands from the centre
susie_x    = room_width / 2 - gap;
ralsei_x   = room_width / 2 + gap;
walk_speed = 1.25;
walk_anim  = 0.65;
talk_wait  = 30;               // after the beckon, before Ralsei talks

// shocked (facing up) once the Knight starts throwing
ralsei_shock_sprite = spr_ralsei_shocked_behind;
susie_shock_sprite  = spr_susie_shocked_up;
// their feet in each sprite's own pixels (bottom-centre of the feet), so the swap doesn't shift them
ralsei_walk_foot  = { x: 10.5, y: 40 }; // spr_ralsei_walk_up
ralsei_shock_foot = { x: 19.5, y: 35 }; // spr_ralsei_shocked_behind
susie_walk_foot  = { x: 13, y: 43 }; // spr_susie_walk_up
susie_shock_foot = { x: 19, y: 43 }; // spr_susie_shocked_up (the back foot, not the kicked-out one)

// --- tuning: the Knight ---
knight_x      = room_width / 2; // his head, over the fountain's centre
knight_head_y = 80;             // his head's height (top-ish of the fountain)
bob_amp       = 4;              // floating bob, px
bob_speed     = 0.03;
// his head (the little cross on top of his helmet) in each sprite's own pixels: swapping sprites keeps this spot still
knight_beckon_head = { x: 27, y: 11 };
knight_throw_head  = { x: 31, y: 22 };
beckon_anim  = 0.25;            // the sprite runs at 30fps, so ~7.5fps
beckon_loops = 2;
throw_wait   = 90;              // after Ralsei's lines, before the throw
throw_anim   = 1;               // spr_roark_throw_sword runs at 10fps

// --- tuning: the swords ---
sword_count        = 5;
sword_x_from       = room_width / 2 - 90;  // spread across in front of Susie and Ralsei
sword_x_to         = room_width / 2 + 90;
sword_y            = 20;                   // where they appear (above his head)
sword_scale        = 2;                    // positive = facing right
sword_spawn_frame  = 14;                   // throw frame where they start appearing (arm up)
sword_hold_frame   = 16;                   // he holds this frame (arm still up) until they're thrown
sword_stagger      = 3;                    // frames between each one appearing, left to right
sword_fade_in      = 6;
sword_hold         = 60;                   // once they're all in: wait this long before throwing
sword_fire_gap     = 5;                    // frames between each throw (one at a time, left to right)
sword_accel        = 1.5;
sword_max_speed    = 26;
sword_appear_sound = noone;                // was snd_spear_appear (snd_empty has a click in it)
sword_drop_sound   = snd_titanfountain;    // its opening is the throw; obj_titan_spawn keeps reading it as its clock
sword_drop_lead    = 0.6;                  // how many seconds before the first throw the sound starts (up to sword_hold / 60)
sword_throw_sound  = noone;                // optional extra sound on every throw (was snd_heavyswing)
snd_drop           = -1;
drop_started       = false;
// the swords draw from here: in front of the fountain (350), behind the floor tiles (300) and everyone else
depth = 320;

// --- state ---
state = "setup";
t = 0;
knight = noone;
knight_y0 = 0;          // his y before the bob
bob = 0;
beckon_count = 0;
beckon_last  = 0;
swords = [];
swords_spawned = false;
swords_all_in  = false;
hold_t   = 0;
firing   = false;
fire_i   = 0;
fire_t   = 0;

set_feet = function(_o, _fx, _fy)
{
    var _f = scr_get_feet(_o);
    _o.x += _fx - _f.x;
    _o.y += _fy - _f.y;
}

/// walks _o straight up until its feet reach _fy. true once it's there
step_up = function(_o, _fy)
{
    if (!instance_exists(_o)) return true;
    var _f = scr_get_feet(_o);
    if (_f.y - _fy <= walk_speed)
    {
        _o.y += _fy - _f.y;
        _o.image_speed = 0;
        _o.image_index = 0;
        return true;
    }
    _o.y -= walk_speed;
    return false;
}

/// swaps _o to _spr so pixel _to of the new sprite lands exactly where pixel _from of the old one was
pose_on_foot = function(_o, _spr, _from, _to)
{
    if (!instance_exists(_o)) return;
    var _fx = _o.x + (_from.x - sprite_get_xoffset(_o.sprite_index)) * _o.image_xscale;
    var _fy = _o.y + (_from.y - sprite_get_yoffset(_o.sprite_index)) * _o.image_yscale;
    _o.sprite_index = _spr;
    _o.last_sprite  = _spr; // placed by hand, so scr_auto_keep_feet leaves it alone
    _o.image_index  = 0;
    _o.image_speed  = 0;
    _o.x = _fx - (_to.x - sprite_get_xoffset(_spr)) * _o.image_xscale;
    _o.y = _fy - (_to.y - sprite_get_yoffset(_spr)) * _o.image_yscale;
}

/// swaps the Knight to _spr so pixel _to of the new sprite lands where pixel _from of the old one was
knight_pose = function(_spr, _from, _to)
{
    if (!instance_exists(knight)) return;
    var _ax = knight.x  + (_from.x - sprite_get_xoffset(knight.sprite_index)) * knight.image_xscale;
    var _ay = knight_y0 + (_from.y - sprite_get_yoffset(knight.sprite_index)) * knight.image_yscale;
    knight.sprite_index = _spr;
    knight.image_index  = 0;
    knight.x  = _ax - (_to.x - sprite_get_xoffset(_spr)) * knight.image_xscale;
    knight_y0 = _ay - (_to.y - sprite_get_yoffset(_spr)) * knight.image_yscale;
}