// rm_two: Susie and Ralsei walk up to the platform's edge side by side, Ralsei pleads
global.cutscene_lock = true;

// --- tuning ---
edge_y     = 364;              // top edge of the floor
stand_y    = edge_y + 30;      // where their feet stop
gap        = 45;               // how far each stands from the centre
susie_x    = room_width / 2 - gap;
ralsei_x   = room_width / 2 + gap;
walk_speed = 1.25;
walk_anim  = 0.65;
talk_wait  = 30;               // frames after they stop before Ralsei talks

// --- state ---
state = "setup";
t = 0;

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