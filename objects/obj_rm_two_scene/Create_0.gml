// rm_two: Susie and Ralsei walk up to the platform's edge, the Knight floats over the fountain and beckons,
// Ralsei pleads, then the Knight throws: 5 swords appear over his head and shoot down into the platform
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
throw_sound  = snd_heavyswing;

// --- tuning: the swords ---
sword_count        = 5;
sword_x_from       = room_width / 2 - 90;  // spread across in front of Susie and Ralsei
sword_x_to         = room_width / 2 + 90;
sword_y            = 20;                   // where they appear (above his head)
sword_scale        = 2;                    // positive = facing right
sword_spawn_frame  = 14;                   // throw frame where they start appearing (arm up)
sword_drop_frame   = 17;                   // throw frame where they shoot down (the swing)
sword_stagger      = 3;                    // frames between each one appearing, left to right
sword_fade_in      = 6;
sword_accel        = 1.5;
sword_max_speed    = 26;
sword_appear_sound = snd_spear_appear;
sword_drop_sound   = snd_ultraswing;

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
swords_spawned  = false;
swords_dropping = false;

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