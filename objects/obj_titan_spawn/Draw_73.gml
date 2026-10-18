// the wide shot's beam + flash: in Draw End so it's in front of the floor and everyone
if (wide)
{
    var _st = cur_wg - slam_g;   // game frames since the slam
    var _vx = camera_get_view_x(view_camera[0]);
    var _vy = camera_get_view_y(view_camera[0]);
    var _vw = camera_get_view_width(view_camera[0]);
    var _vh = camera_get_view_height(view_camera[0]);

    // the beam: the midsection tiled along its length so it runs off the top and bottom of the screen
    if (_st >= 0 && _st < slam_hold_g + slam_thin_g)
    {
        var _w   = (_st < slam_hold_g) ? 1 : 1 - (_st - slam_hold_g) / slam_thin_g;
        var _spr = spr_titanbeam_midsection;
        var _img = floor(_st) mod sprite_get_number(_spr);
        var _h   = sprite_get_height(_spr) * slam_scale;
        var _dir = 270 + slam_angle;   // straight down the beam
        var _ax  = lengthdir_x(1, _dir), _ay = lengthdir_y(1, _dir);
        var _oy  = (sprite_get_yoffset(_spr) - sprite_get_height(_spr) / 2) * slam_scale; // works with any origin
        var _cx  = fx + slam_x, _cy = _vy + _vh / 2;
        for (var k = -1; k <= 1; k++)
        {
            var _d = k * _h + _oy;
            draw_sprite_ext(_spr, _img, _cx + _ax * _d, _cy + _ay * _d, slam_scale * _w, slam_scale, slam_angle, c_white, 1);
        }
    }

    // the white flash
    if (_st >= 0 && _st < slam_flash_g)
    {
        draw_set_alpha(slam_flash * (1 - _st / slam_flash_g));
        draw_set_color(c_white);
        draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
        draw_set_alpha(1);
    }
}