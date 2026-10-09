/// @function scr_box_center()
/// @description World-space center point of obj_battlebox's interior rect.
/// Stable regardless of box_angle (rotation happens around this point).
function scr_box_center()
{
    var _interior = scr_get_box_interior();
    return {
        x: lerp(_interior.x1, _interior.x2, 0.5),
        y: lerp(_interior.y1, _interior.y2, 0.5)
    };
}

/// @function scr_rotate_point(_x, _y, _angle)
/// @description Rotates a vector (_x, _y) by _angle degrees, using the same
/// convention as image_angle/lengthdir (increasing angle = counterclockwise
/// on screen). Works for both position offsets and pure velocity vectors.
function scr_rotate_point(_x, _y, _angle)
{
    if (_x == 0 && _y == 0) return { x: 0, y: 0 };
    var _len = point_distance(0, 0, _x, _y);
    var _dir = point_direction(0, 0, _x, _y) + _angle;
    return { x: lengthdir_x(_len, _dir), y: lengthdir_y(_len, _dir) };
}

/// @function scr_world_to_box_local(_wx, _wy)
/// @description Converts a world-space point into obj_battlebox's local
/// (unrotated) frame — i.e. where this point would be if the box's current
/// spin were undone. In this local frame, scr_get_box_interior()'s x1/y1/x2/y2
/// are always the box walls, no matter how fast the box is spinning.
function scr_world_to_box_local(_wx, _wy)
{
    var _angle = instance_exists(obj_battlebox) ? obj_battlebox.box_angle : 0;
    var _c = scr_box_center();
    var _rel = scr_rotate_point(_wx - _c.x, _wy - _c.y, -_angle);
    return { x: _c.x + _rel.x, y: _c.y + _rel.y };
}

/// @function scr_box_local_to_world(_lx, _ly)
/// @description Inverse of scr_world_to_box_local — converts a point in the
/// box's local (unrotated) frame back into world space at the box's current
/// rotation.
function scr_box_local_to_world(_lx, _ly)
{
    var _angle = instance_exists(obj_battlebox) ? obj_battlebox.box_angle : 0;
    var _c = scr_box_center();
    var _rel = scr_rotate_point(_lx - _c.x, _ly - _c.y, _angle);
    return { x: _c.x + _rel.x, y: _c.y + _rel.y };
}