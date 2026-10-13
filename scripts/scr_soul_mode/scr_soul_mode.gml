/// switches a soul between "red" (normal) and "lightblue" (3x3 grid movement)
function scr_soul_set_mode(_soul, _mode)
{
    with (_soul)
    {
        soul_mode = _mode;
        sprite_index = (_mode == "lightblue" && lightblue_sprite != -1) ? lightblue_sprite : base_sprite;
        grid_c = 1;
        grid_r = 1;
        grid_buffer = -1;
    }
}

/// where the soul's current grid sector sits in the room
function scr_soul_grid_target(_b, _cw, _ch)
{
    var _lx = _b.x1 + (grid_c + 0.5) * _cw;
    var _ly = _b.y1 + (grid_r + 0.5) * _ch;
    if (instance_exists(obj_battlebox) && obj_battlebox.visible) return scr_box_local_to_world(_lx, _ly);
    return { x: _lx, y: _ly };
}

/// light blue movement (runs inside obj_soul): 3x3 sectors, 4 directions, glides between them
function scr_soul_grid_step()
{
    var _b  = scr_get_attack_bounds();
    var _cw = (_b.x2 - _b.x1) / 3;
    var _ch = (_b.y2 - _b.y1) / 3;

    // newest press wins, and a press mid-move is saved for when it arrives
    if (keyboard_check_pressed(vk_right)) grid_buffer = 0;
    if (keyboard_check_pressed(vk_up))    grid_buffer = 1;
    if (keyboard_check_pressed(vk_left))  grid_buffer = 2;
    if (keyboard_check_pressed(vk_down))  grid_buffer = 3;

    var _t = scr_soul_grid_target(_b, _cw, _ch);

    if (point_distance(x, y, _t.x, _t.y) <= grid_ready_dist)
    {
        var _dir = grid_buffer;
        if (_dir == -1)
        {
            // nothing new pressed: keep going whichever way is still held
            if      (keyboard_check(vk_right)) _dir = 0;
            else if (keyboard_check(vk_up))    _dir = 1;
            else if (keyboard_check(vk_left))  _dir = 2;
            else if (keyboard_check(vk_down))  _dir = 3;
        }
        grid_buffer = -1;

        if (_dir != -1)
        {
            grid_c = clamp(grid_c + (_dir == 0) - (_dir == 2), 0, 2);
            grid_r = clamp(grid_r + (_dir == 3) - (_dir == 1), 0, 2);
            _t = scr_soul_grid_target(_b, _cw, _ch);
        }
    }

    x = lerp(x, _t.x, grid_lerp);
    y = lerp(y, _t.y, grid_lerp);

    // grid brightens while it's moving, fades back down when it settles
    var _moving = point_distance(x, y, _t.x, _t.y) > 0.5;
    grid_alpha = lerp(grid_alpha, _moving ? grid_alpha_moving : grid_alpha_idle, 0.15);

    if (!_moving) { x = _t.x; y = _t.y; }
}